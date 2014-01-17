require_relative './spec_helper'

describe 'fish broker' do

	before :each do
		@game_broker = FishBroker.new
	end
	
	it "creates a game" do
		id = 1
		@game_broker.create_game(id)
		@game_broker.game_list[id].class.should == FishGame
	end

	it "can add a player" do
		id = 2
		@game_broker.create_game(id)
		@game_broker.add_player(id, "Jeremy")
		@game_broker.game_list[id].players[0].name.should == "Jeremy"
	end

	it "can add multiple players" do
		id = 3
		@game_broker.create_game(id)
		@game_broker.add_player(id, "Bob")
		@game_broker.add_player(id, "Jim")
		@game_broker.add_player(id, "Sam")
		@game_broker.game_list[id].players.count.should == 3
	end

	it "can setup a game after adding players" do
		id = 4
		@game_broker.create_game(id)
		@game_broker.add_player(id, "Bob")
		@game_broker.add_player(id, "Jim")
		@game_broker.setup_game(id)
		@game_broker.game_list[id].players[0].cards.count.should == 7
		@game_broker.game_list[id].players[1].cards.count.should == 7
	end

	it "can detect when a game is full" do
		id = 4
		@game_broker.create_game(id)
		@game_broker.number_of_players(id, 2)
		@game_broker.add_player(id, "Bob")
		@game_broker.add_player(id, "Jim")
		@game_broker.is_full?(id).should == true
	end

end