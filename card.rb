# frozen_string_literal: true

# class for cards, card have suit, rank and value for scoring.
class Card
  attr_accessor :suit, :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end
