# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'

# Class includes gamers, deck and some actions in process of game.
class Game
  attr_accessor :player, :dealer, :deck, :bank, :score_table, :win_score, :bank_limit

  def initialize
    @BANK_LIMIT = 100
    @BET = 10
    @WIN_SCORE = 21
    @player = Player.new
    @dealer = Dealer.new
    @deck = nil
    @bank = 0
    @win_score = @WIN_SCORE
    @bank_limit = @BANK_LIMIT
  end

  def place_bet(player)
    self.bank += player.make_bet(@BET)
  end

  def break_bank(player)
    player.bank += self.bank
    self.bank = 0
  end

  # блок подсчета очков

  # создает талицу соответствия достоинства карты количесвту очков (туз = 11 очков)
  def refresh_score_table
    self.score_table = {
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
  end

  def shuffle_cards
    @deck.cards.shuffle!.reverse!.shuffle!.reverse!.shuffle! unless @deck.nil? || @deck.cards.size == 0
  end

  def deal_card(player)
    player.recive_card(@deck.cards.shift) unless @deck.nil? || @deck.cards.size == 0
  end

  # создает массив достоинств карт находящихся в руке у игрока и очков соответствующих достоинству и сортирует по старшинству
  def sort_hand(hand)
      @hand = []
      hand.each { |card| @hand << [card.rank, score_table[card.rank]] }
      @hand.sort_by { |_key, value| value }
  end

  # подсчет очков, проверяется наличие туза в руке, если туз стоимостью в 11 очков ведет к перебору, то считаем его за 1 очко
  def count_score(player)
    player.score = 0
    # проверяет, является ли карта тузом
    is_ace = ->(rank) { rank == 'A' }
    refresh_score_table
    @hand = sort_hand(player.hand)
    @hand.each do |rank, value|
      score_table[rank] = 1 if is_ace.call(rank) && (player.score + score_table[rank]) > 21
      player.score += score_table[rank]
    end
  end
end
