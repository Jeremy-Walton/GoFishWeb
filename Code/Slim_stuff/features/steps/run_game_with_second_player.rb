class Spinach::Features::RunGameWithSecondPlayer < Spinach::FeatureSteps
  step 'two people' do
  	::Capybara.session_name = 'first person'
    visit '/login'
	fill_in 'username', :with => 'Jeremy'
	within '#new' do
		choose 'gametype'
	end
	select '2', :from => 'players'
	click_on 'Submit'

	::Capybara.session_name = 'second person'
	visit '/login'
	fill_in 'username', :with => 'Bob'
	fill_in 'game_name', :with => 'Jeremy'
	within '#old' do
		choose 'gametype'
	end
	click_on 'Submit'
  end

  step 'they start a game' do
    # pending 'step not implemented'
  end

  step 'they\'re succesfully added to the same game' do
  	::Capybara.session_name = 'first person'
    game_id = current_scope.session.driver.request.session['game_id']
    user_name = current_scope.session.driver.request.session['user_name']
    game = GoFish.broker.game_list[game_id]
    game.players.count.should == 2
  end
end
