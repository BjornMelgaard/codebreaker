require 'codebreaker/game'
require 'codebreaker/player'
require 'codebreaker/store'

module Codebreaker
  class Codebreaker
    def initialize(arguments, input, output)
      @arguments = arguments
      @game = Game.new(input, output)
    end

    def run
      parse_options
      @game.start
    end

    private

    def parse_options
      options = OptionParser.new
      options.banner = 'Usage: codebreaker [options]'
      options.on('-h', '--help', 'Show this message') { puts(options); exit }
      options.parse!(@arguments)
    end
  end
end
