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
    @deck = nil
    @bank = 0
  end

  def add_gamer(name, bank, type = 'bot')
    self.gamers << Gamer.new(name, bank, type)
  end

  def deal_card(gamer)
    gamer.recive_card(self.deck.deal_card)
  end

  def place_bet(gamer, bet)
    self.bank += gamer.make_bet(bet)
  end

  def break_bank(gamer)
    gamer.bank += self.bank
    self.bank = 0
  end

  def score_set(gamer)
    gamer.score = count_score(gamer.hand)
  end

  def fold(gamer)
    gamer.hand = []
  end
end
