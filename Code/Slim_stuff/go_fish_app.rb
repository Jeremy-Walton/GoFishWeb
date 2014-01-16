require 'sinatra/base'
require 'slim'
require 'pry'
require 'pusher'
require_relative "./fish_game"
require_relative "./fish_hand"
require_relative "./fish_broker"

class LoginScreen < Sinatra::Base

	enable :sessions

	get('/login') { slim :Login }

	get '/gamelist' do
		slim :Game_List
	end

	get '/waitscreen' do
		  redirect '/' #if session['number_of_players'] == GoFish.games[session['game_id']].players.count
	end

	post('/login') do
		# need to check if name is already used.
		if params[:username].strip != '' && params[:gametype] == 'new'
			if(params[:players] == '1')
				session['game_id'] = params[:username]
				GoFish.broker.create_game(session['game_id'])
				GoFish.broker.add_player(session['game_id'], params[:username])
				GoFish.broker.setup_game(session['game_id'])
				GoFish.broker.number_of_players(session['game_id'], 1)
				session['user_name'] = params[:username]
				session['logged_in'] = true
				GoFish.broker.game_list[session['game_id']].set_results('Nobody has gone yet')
				redirect '/'
			else
				session['game_id'] = params[:username]
				session['number_of_players'] = params[:players]
				GoFish.broker.create_game(session['game_id'])
				GoFish.broker.number_of_players(session['game_id'], params[:players])
				session['user_name'] = params[:username]
				session['logged_in'] = true
				GoFish.broker.game_list[session['game_id']].set_results('Nobody has gone yet')
				GoFish.broker.add_player(session['game_id'], params[:username])
				redirect '/'
			end
		elsif params[:gametype] == 'old'
			session['logged_in'] = false
			session['game_id'] = params[:game_name]
			if GoFish.broker.game_list.include?(params[:game_name])
			    # binding.pry
			    if GoFish.broker.is_full?(session['game_id']) == false
			    	GoFish.broker.add_player(params[:game_name], params[:username])
			    end
				session['user_name'] = params[:username]
				session['logged_in'] = true
				GoFish.broker.game_list[session['game_id']].set_results('Nobody has gone yet')
				Pusher['page_update'].trigger('my_event', {
	  					message: 'update page'
				})
				if GoFish.broker.is_full?(session['game_id'])
					GoFish.broker.setup_game(params[:game_name])
				end
				redirect '/'
			else
				redirect '/login'
			end
		else
			redirect '/login'
		end
	end
end

class GoFish < Sinatra::Base
	@@broker = FishBroker.new
	Pusher.url = "http://cb9b39abeab73c4d7276:97dc8edb01064a0a9d6a@api.pusherapp.com/apps/63704"

	def self.broker
		@@broker
	end

  	use LoginScreen

  	before do
   		unless session['logged_in']
     		redirect '/login'
   		end
  	end
  	get '/' do
  		@results = session['results']
  		@game = @@broker.game_list[session['game_id']]
  		@player_names = []
  		@game.players.each do |player|
  			@player_names.push(player.name)
  		end
		@username = session['user_name']
		@results
		@game
		@player_names
		@username
		slim :Go_Fish	
	end

	post('/') do
		@game = @@broker.game_list[session['game_id']]
		@game.players.each do |player|
			if params[:players] == player.name
				@giver = player
			else
			end
		end
		Pusher['page_update'].trigger('my_event', {
  			message: 'update page'
		})
		@game.ask_player_for_card(params[:cards], @game.whos_turn?, @giver)
		redirect '/'
	end

  	get '/rules' do
		slim :Go_Fish_Rules
  	end

	get '/about' do
		slim :Go_Fish_About
	end

	get '/secret' do
  		"Welcome to my secret page! If you found this, you rock!"
	end
end