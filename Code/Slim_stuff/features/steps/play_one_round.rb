class Spinach::Features::PlayOneRound < Spinach::FeatureSteps
  include CommonSteps::Login
  step 'a player viewing the page' do
  	visit '/login'
  	fill_in 'username', :with => 'Jeremy'
    within '#new' do
    	choose 'gametype'
    end
    page.select '1', :from => 'players'
    click_on 'Submit'
    current_path.should == '/'
  end

  step 'they input stuff' do
    page.select 'Jeremy', :from => 'players'
    click_on 'Submit'
  end

  step 'the game does what it is supposed to' do
    page.should have_text 'Jeremy asked'
    game_id = current_scope.session.driver.request.session['game_id']
    user_name = current_scope.session.driver.request.session['user_name']
    game = GoFish.games[game_id]
    cards = game.players[0].cards
    cards.each do |card|
      within '#Hand' do
        page.should have_css("img[src='cards/#{card.suit.downcase}#{card.rank.downcase}.png']")
      end
    end
  end
end
