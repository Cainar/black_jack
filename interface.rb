require_relative 'rendering'

class Interface
  include Rendering

  def initialize(game)
    @game = game
    @player = game.player
    @dealer = game.dealer
    @bank = game.bank
  end

  def greet_player
    @player_name = user_input('    Write your name', -> {gets.chomp.strip}, '    Hello')
    @game.player.name = @player_name unless @player_name.nil? || @player_name.size == 0
    delay(0.5)
  end

  def user_input(message,
                 input_method = -> { getch },
                 result = '')
    print "#{message}: "
    @input = input_method.call
    puts "#{result} #{@input}"
    @input
  end

  def getch
    system('stty raw -echo')
    STDIN.getc
  ensure
    system('stty -raw echo')
  end

  def delay(period = 0.15)
      sleep(period)
  end

  def round
    @switch = true
    loop do
      prepare_game

      dealing

      game_action('place_bet', @game)

      turn_menu
      end_round_menu

      @key = user_input(
        "     press \"Enter\" to continue\n" \
        "     press \"Esc\" to return to the main menu\n" \
      )
      winner_screen
      @switch = false if @key == "\e" || [@player, @dealer].collect(&:bank).include?(0)
      break unless @switch
    end
    start_menu
  end

  def prepare_game
    @game.deck = Deck.new
    @game.deck.shuffle_cards
    draw_desk(@game, @player, @dealer, false)
  end

  def dealing
    2.times { game_action('deal_card', @game.deck) }
    [@player, @dealer].each { |player| player.count_score }
    draw_desk(@game, @player, @dealer, false)
  end

  def winner_screen
    if @player.bank.zero?
      screen_dealer(@dealer)
      delay(1.5)
    elsif @dealer.bank.zero?
      screen_player(@player)
      delay(1.5)
    end
  end

  def game_action(method, object)
    @method = object.method(method.to_sym)
    [@player, @dealer].each do |player|
      @method.call(player)
      draw_desk(object, @player, @dealer, false)
      delay
    end
  end

  def start_menu(header = '  Select to continue')
    [@player, @dealer].each { |player| player.bank = Game::Bank_limit }
    loop do
      draw_header
      show_message
      show_message("  #{header}")
      @key = user_input(
        "     press \"Enter\" to start\n" \
        "     press \"Esc\" to exit\n" \
      )
      break if @key == "\e"
      greet_player
      round if @key == "\r"
      break unless true
    end
  end

  def turn_menu(header = '  Select to continue')
    loop do
      draw_desk(@game, @player, @dealer, false)
      show_message("  #{header}")
      if @player.hand.size < 3
        @key = user_input(
          "     press \"Enter\" to deal card\n" \
          "     press \"Space\" to skip turn\n" \
        )
      end
      @game.deck.deal_card(@player) if @key == "\r"
      if @key == ' ' || @player.hand.size == 3
        @game.deck.deal_card(@dealer) if @dealer.score < 17
      end
      break
      break unless true
    end
    [@player, @dealer].each { |player| player.count_score }
  end

  def end_round_menu(header = '  Select to continue')
    loop do
      draw_desk(@game, @player, @dealer, false)
      show_message("  #{header}")
      @key = user_input(
        "     press \"Enter\" to open\n" \
      )
      break if @key == "\r"
      break unless true
    end
    draw_desk(@game, @player, @dealer, false)
    break_bank
    draw_desk(@game, @player, @dealer)
    [@player, @dealer].each { |player| player.fold }
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

  def decide_winner
    @players = [@player, @dealer]
    if @player.score != @dealer.score
      case @players.select { |player| player.score > Game::Win_score }.size
      when 2 then @players.min_by { |player| (Game::Win_score - player.score).abs }
      when 1 then @players.min_by(&:score)
      when 0 then @players.max_by(&:score)
      end
    else
      @players
    end
  end
end
