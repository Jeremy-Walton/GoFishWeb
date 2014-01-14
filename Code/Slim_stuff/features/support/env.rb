require_relative '../../go_fish_app'

require 'spinach/capybara'
require 'rspec/expectations'
Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)
Capybara.app = GoFish