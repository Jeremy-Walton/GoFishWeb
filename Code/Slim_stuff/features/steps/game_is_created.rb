class Spinach::Features::GameIsCreated < Spinach::FeatureSteps
	include CommonSteps::Login
	step 'a user' do

	end

	step 'it succesfully creates a new game and shows the correct cards' do
		game_id = current_scope.session.driver.request.session['game_id']
		user_name = current_scope.session.driver.request.session['user_name']
		page.should have_content(user_name)
		game = GoFish.games[game_id]
		cards = game.players[0].cards
		cards.each do |card|
			within '#Hand' do
				page.should have_css("img[src='cards/#{card.suit.downcase}#{card.rank.downcase}.png']")
			end
		end
	end
end