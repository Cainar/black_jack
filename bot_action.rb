module BotAction
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    def bot_turn(bot, game)
      if bot.score < 17
        game.deal_card(bot)
      end
    end
  end

  module InstanceMethods

  end
end
