# frozen_string_literal: true

require_relative 'player'
require_relative 'game'
require_relative 'rendering'
require_relative 'interface'

# rubocop:disable Style/Documentation
# rubocop:disable Lint/LiteralAsCondition
# rubocop:disable Naming/VariableName
# rubocop:disable Lint/UnreachableCode
# rubocop:disable Metrics/ClassLength

class Main
  attr_reader :game

  def initialize
    @game = Game.new
  end

  def start
    Interface.new(@game).start_menu
  end
end

m = Main.new
m.start
