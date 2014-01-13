require 'sinatra/base'
require 'slim'
require 'pry'
require_relative "./fish_game"
require_relative "./fish_hand"

class LoginScreen < Sinatra::Base

	enable :sessions

	get('/login') { slim :Login }

	post('/login') do
		# need to check if name is already used.
	unless params[:username].strip == ''
		@game = FishGame.new([FishHand.new([], session['user_name'])])
		@game.setup
		session['game_id'] = @game.object_id
		session['user_name'] = params[:username]
		GoFish.games[@game.object_id] = @game
		redirect '/'
	else
		redirect '/login'
	end
	end
end

class GoFish < Sinatra::Base
	@@games = {}
	def self.games
		@@games
	end
  	use LoginScreen

  	before do
   		unless session['user_name']
     		redirect '/login'
   		end
  	end

  	get '/' do
  		@player_names = []
  		unless @player_names.include?(session['user_name'])
  			@player_names << session['user_name']
  		end
  		@game = @@games[session[:game_id]]
		# binding.pry
		@player_names
		slim :Go_Fish, :locals => {:username => session['user_name'], :game => @game}	
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