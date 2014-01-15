Feature: Join existing game

	a player can choose
	to join an existing game
	and it will bring them to that page

	Scenario: Successful page change
		Given a user
		When I am logged in
		Then it succesfully brings me to the join game page.