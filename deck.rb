# frozen_string_literal: true
require_relative 'card'

# Deck includes cards. The deck can be shuffled
class Deck
  attr_reader :cards

  def initialize
    @cards = []
    @card_back = '# '
    @ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    @suits = { hearts: "\u2665", tiles: "\u2666", clovers: "\u2663", pikes: "\u2660" }
    @suits.each do |suit, symbol|
      @ranks.each do |rank|
        @cards << Card.new(rank, symbol, @card_back)
      end
    end
  end
end
