module StandardSet
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :suits, :ranks, :deck_set

    def create_set
      self.deck_set ||= []
      self.ranks ||= %w[2 3 4 5 6 7 8 9 10 J Q K A]
      self.suits ||= {
        hearts: "\u2665",
        tiles: "\u2666",
        clovers: "\u2663",
        pikes: "\u2660"
      }
      self.suits.each do |suit, symbol|
        self.ranks.each { |rank| self.deck_set << [rank, symbol] }
      end
    end
  end

  module InstanceMethods

  end

end
