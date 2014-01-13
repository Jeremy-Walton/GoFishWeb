require_relative './playing_card'

class Deck

	def initialize
		@cards = []
		ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
		suits = ['h', 's', 'd', 'c']
		1.times do
			ranks.each do |rank|
				suits.each do |suit|
					@cards = @cards.push(PlayingCard.new(rank, suit))
				end
			end
		end
		shuffle
	end

	def size
		@cards.count
	end

	def shuffle
		@cards.shuffle! 
	end

	def take_top_card
		@cards.pop
	end

end