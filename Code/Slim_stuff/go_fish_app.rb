require 'sinatra'
require 'slim'

get '/' do

	slim :Go_Fish
	
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