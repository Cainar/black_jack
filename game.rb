# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'

# Class includes gamers, deck and some actions in process of game.
class Game
  attr_accessor :player, :dealer, :deck, :bank, :score_table

  Bank_limit = 100
  Bet = 10
  Win_score = 21
  Score_table = {
      '2' => 2,
      '3' => 3,
      '4' => 4,
      '5' => 5,
      '6' => 6,
      '7' => 7,
      '8' => 8,
      '9' => 9,
      '10' => 10,
      'J' => 10,
      'Q' => 10,
      'K' => 10,
      'A' => 11
    }

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck
    @bank = 0
  end

  def place_bet(player)
    self.bank += player.make_bet(Game::Bet)
  end

  def break_bank(player)
    player.bank += self.bank
    self.bank = 0
  end
end
