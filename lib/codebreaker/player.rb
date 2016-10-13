require 'colorize'

module Codebreaker
  # view
  class Player
    def initialize(input, output)
      @input, @output = input, output
    end

    def welcome
      commands = %w(hint exit restart).map(&:red).join(', ')
      puts "\n    Welcome to Codebreaker.\n" \
           "    Try to guess secret code.\n" \
           "    Also you have available commands at any time: #{commands}.\n"
    end

    def ask_name
      name = request('    But first, please, enter your name: ')
      puts "    OK, we can start\n\n"
      name
    end

    def bye
      puts 'See you space, cowboy ヾ(^_^)'.blue
    end

    def puts(msg)
      @output.puts msg
    end

    def yes?(msg)
      request(msg + ' (y/n): ').casecmp('y').zero?
    end

    def request(msg)
      @output.print(msg)
      @input.gets.chomp
    rescue NoMethodError
      exit
    end
  end
end
