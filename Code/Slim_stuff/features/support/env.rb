require_relative '../../go_fish_app'
require_relative '../../fish_game'
require_relative '../../fish_hand'
require_relative '../../deck'
require_relative '../../fish_player'
require_relative '../../playing_card'
require_relative '../../round_results'

require 'spinach/capybara'
require 'rspec/expectations'
Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)
Capybara.app = GoFish