require_relative 'standard_set'
require_relative 'card'

class Deck
  include StandardSet

  attr_reader :cards

  create_set

  def initialize
    @cards = []
    self.class.deck_set.each do |rank, symbol|
      @cards << Card.new(rank, symbol, self.class.card_back)
    end
  end

  def shuffle_cards
    self.cards.shuffle!.reverse!.shuffle!.reverse!.shuffle!
  end

  def deal_card
    self.cards.shift
  end
end
