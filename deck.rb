# frozen_string_literal: true
require_relative 'card'

# Deck includes cards. The deck can be shuffled
class Deck
  attr_reader :cards

  Suits = { hearts: "\u2665", tiles: "\u2666", clovers: "\u2663", pikes: "\u2660" }
  Ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A]

  def initialize
    @cards = []
    Suits.each do |suit, symbol|
      Ranks.each do |rank|
        @cards << Card.new(rank, symbol)
      end
    end
  end

  def shuffle_cards
    @cards.shuffle! unless @cards.nil? || @cards.size == 0
  end

  def deal_card(player)
    player.recive_card(@cards.shift) unless @cards.nil? || @cards.size == 0
  end
end
