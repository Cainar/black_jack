# frozen_string_literal: true

require_relative 'game'
require_relative 'bot_action'
require_relative 'rendering'

# rubocop:disable Style/Documentation
# rubocop:disable Lint/LiteralAsCondition
# rubocop:disable Naming/VariableName
# rubocop:disable Lint/UnreachableCode
# rubocop:disable Metrics/ClassLength
class Desk
  include BotAction
  include Rendering

  attr_accessor :game, :gamers, :person, :bot

  @BANK_LIMIT = 100
  @BET = 10
  @WIN_SCORE = 21

  class << self
    def getch
      system('stty raw -echo')
      STDIN.getc
    ensure
      system('stty -raw echo')
    end

    def delay(period = 0.1)
      sleep(period)
    end

    def show_message(message = '', method = :puts)
      send(method, message)
    end

    def user_input(message,
                   input_method = -> { getch },
                   result = '')
      print "#{message}: "
      @input = input_method.call
      puts "#{result} #{@input}"
      @input = 'Unnamed' if @input == ''
      @input
    end

    def take_seats
      @game.add_gamer(
        user_input(
          '    Write your name',
          -> { gets.chomp.strip },
          '    Welcome'
        ),
        @BANK_LIMIT,
        'person'
      )
      @game.add_gamer('SkyNET', @BANK_LIMIT)
    end

    def game_action(method)
      @method = @game.method(method.to_s.to_sym)
      @gamers.each do |gamer|
        @method.call(gamer)
        draw_desk(@person.show_cards, @bot.show_cards_back)
        delay
      end
    end

    def place_bets
      @gamers.each do |gamer|
        @game.place_bet(gamer, @BET)
        draw_desk(@person.show_cards, @bot.show_cards_back, @person.score)
        delay
      end
    end

    def decide_winner
      if @person.score != @bot.score
        case @gamers.select { |gamer| gamer.score > @WIN_SCORE }.size
        when 2 then @gamers.min_by { |gamer| (@WIN_SCORE - gamer.score).abs }
        when 1 then @gamers.min_by(&:score)
        when 0 then @gamers.max_by(&:score)
        end
      else
        @gamers
      end
    end

    def break_bank
      @winner = decide_winner
      if @winner.class == Array
        @half = @game.bank / @winner.size
        @winner.each do |gamer|
          @game.bank = @half
          @game.break_bank(gamer)
        end
      else
        @game.break_bank(@winner)
      end
    end

    def draw_desk(gamer_hand = '', bot_hand = '', gamer_score = '', bot_score = '')
      draw_footer
      puts(
        "                   #{@bot.name}: #{@bot.bank}$    \n"\
        "                ----------------               \n"\
        "                  #{bot_score}                 \n"\
        "             --                  --            \n"\
        "                  #{bot_hand}                  \n"\
        "            --                    --           \n"\
        "                 bank: #{@game.bank}$               \n"\
        "            --                    --           \n"\
        "                  #{gamer_hand}                \n"\
        "             --                  --            \n"\
        "                  #{gamer_score}               \n"\
        "                ----------------               \n"\
        "                   #{@person.name}: #{@person.bank}$\n"\
        "\n\n"
      )
    end

    def round
      @game = Game.new
      take_seats
      @gamers = @game.gamers
      @bot = @gamers.last
      @person = @gamers.first
      @bank = @game.bank

      step
    end

    def step
      @switch = true
      loop do
        @game.deck = Deck.new
        @game.deck.shuffle_cards
        draw_desk
        delay

        2.times { game_action('deal_card') }
        game_action('score_set')
        place_bets

        menu_2
        game_action('score_set')
        draw_desk(@person.show_cards, @bot.show_cards_back, @person.score)

        menu_3
        draw_desk(@person.show_cards, @bot.show_cards, @person.score, @bot.score)

        break_bank
        draw_desk(@person.show_cards, @bot.show_cards, @person.score, @bot.score)
        delay(1)

        game_action('fold')

        @key = user_input(
          "     press \"Enter\" to continue\n" \
          "     press \"Esc\" to return to the main menu\n" \
        )
        screen_1 if @person.bank.zero?
        screen_2 if @bot.bank.zero?
        @switch = false if @key == "\e" || @gamers.collect(&:bank).include?(0)
        break unless @switch
      end
      start
    end

    def menu(header = '  Select to continue')
      loop do
        draw_footer
        show_message("  #{header}")
        @key = user_input(
          "     press \"Enter\" to start\n" \
          "     press \"Esc\" to exit\n" \
        )
        round if @key == "\r"
        break if @key == "\e"
        break unless true
      end
    end

    def menu_2(header = '  Select to continue')
      @gamers = @game.gamers
      @person = @gamers.first
      @bot = @gamers.last
      loop do
        draw_desk(@person.show_cards, @bot.show_cards_back, @person.score)
        show_message("  #{header}")
        if @person.hand.size < 3
          @key = user_input(
            "     press \"Enter\" to deal card\n" \
            "     press \"Space\" to skip turn\n" \
          )
        end
        @game.deal_card(@person) if @key == "\r"
        bot_turn(@bot, @game) if @key == ' ' || @person.hand.size == 3
        break
        break unless true
      end
    end

    def menu_3(header = '  Select to continue')
      loop do
        draw_desk(@person.show_cards, @bot.show_cards_back, @person.score)
        show_message("  #{header}")
        @key = user_input(
          "     press \"Enter\" to open\n" \
        )
        break if @key == "\r"
        break unless true
      end
    end

    def start
      Desk.menu
    end
  end
end
# rubocop:enable Style/Documentation
# rubocop:enable Lint/LiteralAsCondition
# rubocop:enable Naming/VariableName
# rubocop:enable Lint/UnreachableCode
# rubocop:enable Metrics/ClassLength
Desk.start
