require 'pry'


class Spinach::Features::GameTakesSuccesfullTurnsWithMultiplePlayers < Spinach::FeatureSteps
  step 'multiple people' do
    ::Capybara.session_name = 'first person'
    visit '/login'
	fill_in 'username', :with => 'Jeremy'
	within '#new' do
		choose 'gametype'
	end
	select '3', :from => 'players'
	click_on 'Submit'
  end

  step 'they start a game' do
    ::Capybara.session_name = 'second person'
	visit '/login'
	fill_in 'username', :with => 'Bob'
	fill_in 'game_name', :with => 'Jeremy'
	within '#old' do
		choose 'gametype'
	end
	click_on 'Submit'

	::Capybara.session_name = 'third person'
	visit '/login'
	fill_in 'username', :with => 'Sam'
	fill_in 'game_name', :with => 'Jeremy'
	within '#old' do
		choose 'gametype'
	end
	click_on 'Submit'
  end

  step 'they\'re each succesfully able to play one turn' do
    ::Capybara.session_name = 'first person'
    current_path.should == '/'

    ::Capybara.session_name = 'second person'
    current_path.should == '/'

    ::Capybara.session_name = 'third person'
    current_path.should == '/'
    page.should have_text '| Jeremy | | Bob | | Sam |'

    ::Capybara.session_name = 'first person'
    visit '/'
    within '#Interface' do
      page.select 'Bob', :from => 'players'
      click_on 'Submit'
    end
    page.should have_text 'Jeremy asked'

    ::Capybara.session_name = 'second person'
    within '#Interface' do
      page.select 'Sam', :from => 'players'
      click_on 'Submit'
    end
    page.should have_text 'Bob asked'

    ::Capybara.session_name = 'third person'
    visit '/'
    within '#Interface' do
      page.select 'Jeremy', :from => 'players'
      click_on 'Submit'
    end
    page.should have_text 'Sam asked'

  end
end
