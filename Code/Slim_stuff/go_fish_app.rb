require 'sinatra/base'
require 'slim'
require 'pry'
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

	# post '/gamelist' do
	# 	if GoFish.broker.game_list.include?(params[:game_name])
	# 		# binding.pry
	# 		GoFish.broker.add_player(params[:game_name], session['user_name'])
	# 		session['logged_in'] = true
	# 		binding.pry
	# 		redirect '/'
	# 	else
	# 		redirect '/login'
	# 	end
	# end

	post('/login') do
		session['player_names'] = []
		# need to check if name is already used.
		if params[:username].strip != '' && params[:gametype] == 'new'
			if(params[:players] == '1')
				session['game_id'] = params[:username]
				GoFish.broker.create_game(session['game_id'])
				GoFish.broker.add_player(session['game_id'], params[:username])
				GoFish.broker.setup_game(session['game_id'])
				session['user_name'] = params[:username]
				session['logged_in'] = true
				session['player_names'].push(params[:username])
				session['results'] = 'Nobody has gone yet'
				redirect '/'
			else
				session['game_id'] = params[:username]
				session['number_of_players'] = params[:players]
				GoFish.broker.create_game(session['game_id'])
				session['user_name'] = params[:username]
				session['logged_in'] = true
				session['player_names'].push(params[:username])
				session['results'] = 'Nobody has gone yet'
				GoFish.broker.add_player(session['game_id'], params[:username])
				# binding.pry
				redirect '/waitscreen'
			end
		elsif params[:gametype] == 'old'
			session['logged_in'] = false
			if GoFish.broker.game_list.include?(params[:game_name])
			    # binding.pry
				GoFish.broker.add_player(params[:game_name], params[:username])
				session['game_id'] = params[:game_name]
				session['player_names'].push(params[:username])
				session['logged_in'] = true
				# binding.pry
				# if session['number_of_players'] == GoFish.broker.game_list[session['game_id']].players.count
					GoFish.broker.setup_game(params[:game_name])
					binding.pry
				# end
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
  		# player names need to be consistent instead of session based. You can get them from the game.
  		@player_names = []
  		unless @player_names.include?(session['user_name'])
  			@player_names << session['user_name']
  		end
  		@results = session[:results]
  		@game = @@broker.game_list[session['game_id']]
		@player_names = session['player_names']
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
		# Need to make this per game instead of universal
		session[:results] = @game.ask_player_for_card(params[:cards], @game.whos_turn?, @giver)
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