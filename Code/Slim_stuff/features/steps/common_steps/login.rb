module CommonSteps
    module Login
        include Spinach::DSL

	    step 'I am logged in' do
			visit '/login'
			fill_in 'username', :with => 'Jeremy'
			within '#new' do
				choose 'gametype'
			end
			select '1', :from => 'players'
			click_on 'Submit'
	    end
    end
end
