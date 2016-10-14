require 'colorize'

module Codebreaker
  # view
  class UI
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

    def yes?(msg)
      request(msg + ' (y/n): ').casecmp('y').zero?
    end

    def puts(_msg)
      raise NotImplementedError, 'This method intended to print '\
        'message and add a newline'
    end

    def request(_msg)
      raise NotImplementedError, 'This method intended to print '\
        'message and request string from input'
    end
  end
end
