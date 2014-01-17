Feature: Game takes succesfull turns with multiple players

	multiple people can connect to the same game and each play a turn

	Scenario: Successful turn
		Given multiple people
		When they start a game
		Then they're each succesfully able to play one turn