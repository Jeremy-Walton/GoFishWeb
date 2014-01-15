Feature: Identify Player

	As the owner of the game

	Scenario: Successful player identification
		Given a first time user
		When they identify themselves by name
		Then they're succesfully redirected to the game page