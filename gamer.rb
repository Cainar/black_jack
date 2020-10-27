class Gamer
  attr_accessor :name, :score, :hand, :bank
  attr_reader :type

  def initialize(name, bank, type)
    @name = name
    @score = 0
    @hand = []
    @bank = bank
    @type = type
  end

  def make_bet(bet)
    @bank -= bet
    bet
  end

  def show_cards
    @view = []
    self.hand.each { |card| @view << "[#{card.face}]"}
    @view.join
  end

  def show_cards_back
    @view = []
    self.hand.each { |card| @view << "[#{card.back}]"}
    @view.join
  end

  def recive_card(card)
    self.hand << card
  end
end
