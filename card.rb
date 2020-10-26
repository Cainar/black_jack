# class for cards, card have suit, rank and value for scoring.
class Card
  attr_accessor :suit, :rank, :icon

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @icon = "#{rank}#{suit}"
  end
end
