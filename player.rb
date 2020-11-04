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

  def show_cards(side = 'face')
    @view = []
    self.hand.each { |card| @view << "[#{card.method(side.to_sym).call}]" }
    @view.join
  end

  def recive_card(card)
    hand << card
  end

  def fold
    self.hand = []
  end
end

class Dealer < Player
  def initialize(name = 'SkyNet')
    @name = name
    super
  end
end
