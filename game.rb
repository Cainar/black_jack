require_relative 'deck'
require_relative 'gamer'
require_relative 'scoring'
# require_relative 'standard_set'
# require_relative 'card'

class Game
  include Scoring

  attr_accessor :gamers, :deck, :bank

  def initialize
    @gamers = []
    @deck = Deck.new
    @bank = 0
  end

  def add_gamer(name, bank, type = 'bot')
    self.gamers << Gamer.new(name, bank, type)
  end

  def deal_card(gamer)
    gamer.recive_card(self.deck.deal_card)
  end
end
