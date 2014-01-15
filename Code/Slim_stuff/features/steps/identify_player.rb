class Spinach::Features::IdentifyPlayer < Spinach::FeatureSteps
  step 'a first time user' do
  	visit '/login'
  end

  step 'they identify themselves by name' do
    fill_in 'username', :with => 'Jeremy'
    within '#new' do
    	choose 'gametype'
    end
    page.select '1', :from => 'players'
    click_on 'Submit'
  end

  step 'they\'re succesfully redirected to the game page' do
    current_path.should == '/'
  end
end
