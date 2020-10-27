# frozen_string_literal: true

# class for cards, card have suit, rank and value for scoring.
class Card
  attr_accessor :suit, :rank, :face, :back

  def initialize(rank, suit, back)
    @rank = rank
    @suit = suit
    @face = "#{rank}#{suit}"
    @back = "#{back} "
  end
end
