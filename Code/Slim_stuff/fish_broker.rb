require_relative './fish_game.rb'

class FishBroker 
	attr_reader :game_list
	def initialize
		@game_list = {}
	end

	def create_game(game_id)
		@game_list[game_id] = FishGame.new
	end

	def add_player(game_id, name)
		@game_list[game_id].add_player(name)
	end

	def setup_game(game_id)
		@game_list[game_id].setup
	end

end