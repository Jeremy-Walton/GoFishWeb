Feature: Game is created

	once a player starts
	a game is created
	and the page shows his cards

	Scenario: Successful game creation
		Given a user
		When I am logged in
		Then it succesfully creates a new game and shows the correct cards