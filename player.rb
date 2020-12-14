# frozen_string_literal: true

require_relative 'hand'

# class for gamers includes name, score, gamer bank and recived cards
class Player
  attr_accessor :name, :score, :hand, :bank

  def initialize(name = "Anonymous")
    @name = name
    @bank = bank
    @hand = Hand.new
  end

  def make_bet(bet)
    @bank -= bet
    bet
  end

  def show_cards(face = true)
    @view = []
    if face
      @hand.cards.each { |card| @view << "[#{card.rank}#{card.suit}]" }
      @view.join
    else
      @hand.cards.each { |card| @view << "[ #]" }
      @view.join
    end
  end

  def recive_card(card)
    @hand.cards << card
  end

  def fold
    @hand.cards = []
  end
end

class Dealer < Player
  def initialize(name = 'SkyNet')
    @name = name
    super
  end
end
