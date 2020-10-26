class Gamer
  attr_accessor :name, :score, :hand, :bank

  def initialize(name, bank)
    @name = name
    @score = 0
    @hand = []
    @bank = bank
  end

  def make_bet(bet)
    @bank -= bet
    bet
  end

  def show_cards
    print "#{self.name}:    "
    self.hand.each { |card| print "[#{card.face}]"}
  end

  def show_cards_back
    print "#{self.name}:    "
    self.hand.each { |card| print "[#{card.back}]"}
  end

  def recive_card(card)
    self.hand << card
  end
end
