# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'

# Class includes gamers, deck and some actions in process of game.
class Game
  attr_accessor :player, :dealer, :deck, :bank

  BANK_LIMIT = 100
  BET = 10
  WIN_SCORE = 21
  SCORE_TABLE = {
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
    @bank = 0
  end

  def place_bet(player)
    self.bank += player.make_bet(Game::BET)
  end

  def break_bank(player)
    player.bank += self.bank
    self.bank = 0
  end

  def prepare_game
    @deck = Deck.new
    @deck.shuffle_cards
  end

  def dealing
    2.times { game_action('deal_card', @deck) }
    [@player, @dealer].each { |player| player.hand.count_score }
  end

  def game_action(method, object)
    @method = object.method(method.to_sym)
    [@player, @dealer].each do |player|
      @method.call(player)
    end
  end

  def break_game_bank
    @winner = decide_winner
    if @winner.class == Array
      @half = @bank / @winner.size
      @winner.each do |gamer|
        @bank = @half
        break_bank(gamer)
      end
    else
      break_bank(@winner)
    end
  end

  def decide_winner
    @players = [@player, @dealer]
    if @player.hand.score != @dealer.hand.score
      case @players.select { |player| player.hand.score > WIN_SCORE }.size
      when 2 then @players.min_by { |player| (WIN_SCORE - player.hand.score).abs }
      when 1 then @players.min_by { |player| player.hand.score }
      when 0 then @players.max_by { |player| player.hand.score }
      end
    else
      @players
    end
  end
end
