require_relative 'game'

class Desk
  attr_accessor :game

  @BANK_LIMIT = 100

  class << self
    def delay(period = 0.8)
      sleep(period)
    end

    def show_message(message = "", method = :puts)
      send(method, message)
    end

    def user_input(message, result = "Your input:")
      print "#{message}: "
      @input = gets.chomp.strip
      puts "#{result} #{@input}"
      @input
    end

    def deal_cards
      @gamers = @game.gamers
      @person = @gamers.first
      @bot = @gamers.last
      @gamers.each do |gamer|
        @game.deal_card(gamer)
        draw_desk(@person.show_cards, @bot.show_cards_back)
        delay
      end
    end

    def draw_footer
      system('clear')
      show_message(
        "************************************************\n"\
        "--------------------      ----------------------\n"\
        "-----------------             ------------------\n"\
        "----------------   BLACKJACK   -----------------\n"\
        "-----------------             ------------------\n"\
        "--------------------      ----------------------\n"\
        "************************************************\n"\
        "\n\n"
      )
    end

    def draw_desk(gamer_hand = '', bot_hand = '')
      draw_footer
      @bot = @game.gamers.last
      @person = @game.gamers.first
      puts(
        "                #{@bot.name} (#{@bot.type})    \n"\
        "                ----------------               \n"\
        "              --                --             \n"\
        "             --                  --            \n"\
        "                  #{bot_hand}                  \n"\
        "            --                    --           \n"\
        "            --                    --           \n"\
        "                  #{gamer_hand}                \n"\
        "             --                  --            \n"\
        "              --                --             \n"\
        "                ----------------               \n"\
        "                 #{@person.name}               \n"\
        "\n\n"
      )
    end

    def begining
      draw_footer
      @game = Game.new
      @game.deck.shuffle_cards
      @game.add_gamer(user_input('Write your name', 'Welcome'), @BANK_LIMIT, 'persons')
      @game.add_gamer('SkyNET', @BANK_LIMIT)

      delay
      draw_desk
      delay(1)
      2.times { deal_cards }
      user_input('Write your name')
    end

    def menu
      begin
        draw_footer
        show_message("Select to continue")
        show_message
        show_message
        @choice = user_input(
          "   press 1 to start\n" \
          "   press 0 to exit\n" \
          )
        delay
        begining if @choice == "1"
        break if @choice == "0"
      end while true
    end
  end



  #draw_footer
  #
end
