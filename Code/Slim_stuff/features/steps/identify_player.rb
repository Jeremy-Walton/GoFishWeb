class Spinach::Features::IdentifyPlayer < Spinach::FeatureSteps
  step 'a first time user' do
  end

  step 'they identify themselves by name' do
    visit '/login'
    fill_in 'username', :with => 'Jeremy'
    click_on 'Submit'
  end

  step 'they\'re succesfully associated with a new game and redirected to the game page' do
    page.should have_content("Cards")
  end
end
