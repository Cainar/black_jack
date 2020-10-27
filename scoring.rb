module Scoring
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods

  end

  module InstanceMethods
    attr_accessor :find_ace, :score_table, :score

    def refresh_score_table
      self.score_table = {
        "2" => 2,
        "3" => 3,
        "4" => 4,
        "5" => 5,
        "6" => 6,
        "7" => 7,
        "8" => 8,
        "9" => 9,
        "10" => 10,
        "J" => 10,
        "Q" => 10,
        "K" => 10,
        "A" => 11
      }
    end

    def sort_hand(hand)
      @hand = []
      hand.each { |card| @hand << [card.rank, self.score_table[card.rank]] }
      @hand.sort_by { |key, value| value }
    end

    def count_score(hand)
      is_ace = ->(rank) { rank == "A" ? true : false }
      self.score = 0
      refresh_score_table
      @hand = sort_hand(hand)
      @hand.each do |rank, value|
        if is_ace.call(rank) && (self.score + score_table[rank]) > 21
          score_table[rank] = 1
        end
        self.score += score_table[rank]
      end
      self.score
    end
  end
end
