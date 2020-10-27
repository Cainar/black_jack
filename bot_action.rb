# frozen_string_literal: true

# rubocop:disable Style/Documentation
module BotAction
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    def bot_turn(bot, game)
      game.deal_card(bot) if bot.score < 17
    end
  end

  module InstanceMethods
  end
end

# rubocop:enable Style/Documentation
