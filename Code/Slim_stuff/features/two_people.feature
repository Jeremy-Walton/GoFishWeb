Feature: Run game with second player

	two people can connect to the same game instead of getting seperate games.

	Scenario: Successful game joining
		Given two people
		When they start a game
		Then they're succesfully added to the same game