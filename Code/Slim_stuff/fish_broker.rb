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

	def add_robot(game_id, name)
		@game_list[game_id].add_robot(name)
	end

	def setup_game(game_id)
		@game_list[game_id].setup
	end

	def number_of_players(game_id, players)
		@game_list[game_id].set_max_players(players)
	end

	def is_full?(game_id)
		@game_list[game_id].players.count == @game_list[game_id].max_players.to_i
	end

end