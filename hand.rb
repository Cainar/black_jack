require_relative 'game'

class Hand
  attr_accessor :cards, :score

  def initialize
  	@cards = []
  	@score = 0
  end

  # подсчет очков, проверяется наличие туза в руке, если туз стоимостью в 11 очков ведет к перебору, то считаем его за 1 очко
  def count_score
    @score = 0
    # проверяет, является ли карта тузом
    is_ace = ->(rank) { rank == 'A' }
    @cards.sort_by { |card| Game::SCORE_TABLE[card.rank] }.each do |card|
      @score += Game::SCORE_TABLE[card.rank]
      @score -= 10 if is_ace.call(card.rank) && @score > Game::WIN_SCORE
    end
  end

  def enough
  	@score >= 17
  end
end