require 'sinatra/base'
require 'slim'
require 'pry'
require 'pusher'
require_relative "./fish_game"
require_relative "./fish_hand"
require_relative "./fish_broker"

# use game broker with socket server. players on sockets vs players on browser.
# canasta as an option (for those who don't want to play go fish)
# robot players.

# Game needs to detect who won
# Refactor.
# Push by noon.
class GameScreen < Sinatra::Base
	Pusher.url = "http://cb9b39abeab73c4d7276:97dc8edb01064a0a9d6a@api.pusherapp.com/apps/63704"
	def refresh_page
		Pusher['page_update'].trigger('my_event', {
	  		game_id: session['game_id']
		})
	end
end

class LoginScreen < GameScreen

	enable :sessions

	get('/login') { slim :Login }

	get '/gamelist' do
		slim :Game_List
	end

	get '/winscreen' do
		session.delete('logged_in')
		GoFish.broker.game_list.delete(session['game_id'])
		'What you doing here???'
		# binding.pry
	end

	def set_session_variables(username)
		session['game_id'] = username
		session['user_name'] = username
		session['logged_in'] = true
	end

	def prepare_game(username, players)
		GoFish.broker.create_game(session['game_id'])
		GoFish.broker.number_of_players(session['game_id'], players)
		GoFish.broker.game_list[session['game_id']].set_results('Nobody has gone yet')
		GoFish.broker.add_player(session['game_id'], username)
	end

	def start_game(game_name)
		GoFish.broker.setup_game(game_name)
	end

	post('/login') do
		if params[:username].strip != '' && params[:gametype] == 'new'
			if(params[:players] == '1')
				set_session_variables(params[:username])
				prepare_game(params[:username], params[:players])
				start_game(session['game_id'])
				redirect '/'
			else
				set_session_variables(params[:username])
				prepare_game(params[:username], params[:players])
				redirect '/'
			end
		elsif params[:gametype] == 'old'
			game_list = GoFish.broker.game_list
			session['logged_in'] = false
			session['game_id'] = params[:game_name]
			if game_list.include?(params[:game_name])
				session['user_name'] = params[:username]
				session['logged_in'] = true
				game_list[session['game_id']].set_results('Nobody has gone yet')
			    if GoFish.broker.is_full?(session['game_id']) == false
			    	GoFish.broker.add_player(params[:game_name], params[:username])
			    	if GoFish.broker.is_full?(session['game_id'])
						start_game(params[:game_name])
					end
			    else
			    	redirect '/login'
			    end
				refresh_page
				redirect '/'
			else
				redirect '/login'
			end
		else
			redirect '/login'
		end
	end
end

class GoFish < GameScreen
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
  		@results = session['results']
  		@game = @@broker.game_list[session['game_id']]
  		if @game.deck.size == 0 || @game.nil?
			redirect '/winscreen'
		end
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
		refresh_page
		@game.ask_player_for_card(params[:cards], @game.whos_turn?, @giver)
		@game.players.each do |player|
			if player.cards.count == 0
				player.take_cards(@game.go_fish)
			end
		end
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