# frozen_string_literal: true

# rubocop:disable Style/Documentation
module Scoring
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    attr_accessor :find_ace, :score_table, :score
    # rubocop:disable Metrics/MethodLength
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

    # rubocop:enable Metrics/MethodLength
    def sort_hand(hand)
      @hand = []
      hand.each { |card| @hand << [card.rank, score_table[card.rank]] }
      @hand.sort_by { |_key, value| value }
    end

    # rubocop:disable Metrics/AbcSize
    def count_score(hand)
      is_ace = ->(rank) { rank == 'A' }
      self.score = 0
      refresh_score_table
      @hand = sort_hand(hand)
      @hand.each do |rank, _value|
        score_table[rank] = 1 if is_ace.call(rank) && (score + score_table[rank]) > 21
        self.score += score_table[rank]
      end
      self.score
    end
    # rubocop:enable Metrics/AbcSize
  end
end
# rubocop:enable Style/Documentation
