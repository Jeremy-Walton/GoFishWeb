class Spinach::Features::JoinExistingGame < Spinach::FeatureSteps
  step 'a user' do
  end

  step 'I am logged in' do
	visit '/login'
	fill_in 'username', :with => 'Jeremy'
	within '#old' do
		choose 'gametype'
	end
	click_on 'Submit'
  end

  step 'it succesfully brings me to the join game page.' do
    #  Wrong
    pending 'need to implement'
    # current_path.should == '/login'
  end
end
