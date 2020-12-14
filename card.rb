# frozen_string_literal: true

# class for cards, card have suit, rank and value for scoring.
class Card
  attr_accessor :suit, :rank

  SUITS = { hearts: "\u2665", tiles: "\u2666", clovers: "\u2663", pikes: "\u2660" }
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end
