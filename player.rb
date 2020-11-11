# frozen_string_literal: true

# class for gamers includes name, score, gamer bank and recived cards
class Player
  attr_accessor :name, :score, :hand, :bank

  def initialize(name = "Anonymous")
    @name = name
    @score = 0
    @hand = []
    @bank = bank
  end

  def make_bet(bet)
    @bank -= bet
    bet
  end

  def show_cards(face = true)
    @view = []
    if face
      @hand.each { |card| @view << "[#{card.rank}#{card.suit}]" }
      @view.join
    else
      @hand.each { |card| @view << "[ #]" }
      @view.join
    end
  end

  def recive_card(card)
    @hand << card
  end

  def fold
    @hand = []
  end

  # подсчет очков, проверяется наличие туза в руке, если туз стоимостью в 11 очков ведет к перебору, то считаем его за 1 очко
  def count_score
    @score = 0
    # проверяет, является ли карта тузом
    is_ace = ->(rank) { rank == 'A' }
    @hand.sort_by { |card| Game::Score_table[card.rank] }.each do |card|
      @score += Game::Score_table[card.rank]
      @score -= 10 if is_ace.call(card.rank) && @score > Game::Win_score
    end
  end
end

class Dealer < Player
  def initialize(name = 'SkyNet')
    @name = name
    super
  end
end
