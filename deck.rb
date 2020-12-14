# frozen_string_literal: true
require_relative 'card'

# Deck includes cards. The deck can be shuffled
class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit, symbol|
      Card::RANKS.each do |rank|
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
