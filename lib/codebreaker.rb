require 'codebreaker/game'
require 'codebreaker/marker'

#
module Codebreaker
  class Codebreaker
    def initialize
      commands = %w(hint exit restart)\
                 .map { |command| Colorizer.red(command) }.join(', ')

      puts '    Welcome to Codebreaker.'
      puts '    Try to guess secret code.\n'
      puts "    Also you have available commands at any time: #{commands}."
      print '    But first, please, enter your name: '
      name = gets.chomp

      puts "    OK, we can start\n\n"

      input = ''
      loop do
        output, invitation = game.iterate(input)
        puts output
        break if game.ended?
        print invitation
        input = gets.chomp
      end

      'Do you want to try again?'
      puts 'See you space, cowboy ヾ(^_^)'.blue
    end

    def play
      @ui.welcome
      @name = @ui.ask_name
      catch :end_play do
        loop do
          reset_assets!
          play # throw :end_play when win or loose or exit
          @ui.puts "\nGame has been restarted"
        end
      end
      show_score if @ui.yes?('Can I print score?')
      @store.save_scores
      @ui.bye
    end

    def get_game_for(name)

    end
  end
end
