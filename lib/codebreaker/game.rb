require 'colorize'

module Codebreaker
  # controller
  class Game
    ATTEMPTS_COUNT = 10
    SECRET_LENGTH = 4

    def initialize(input, output)
      @player = Player.new(input, output)
      @store = Store.new
    end

    def start
      @player.welcome
      @name = @player.ask_name
      catch :end_play do
        loop do
          reset_assets!
          play # throw :end_play when win or loose
          @player.puts "\nGame has been restarted"
        end
      end
      show_score if @player.yes?('Can I print score?')
      @store.save_scores
      @player.bye
    end

    def play
      @started_at = Time.now
      @continue_play = true
      request_str = 'Enter your guess: '
      while @continue_play
        case attempt = @player.request(request_str)
        when 'hint' then hint
        when 'exit' then throw :end_play
        when 'restart' then @continue_play = false
        else guess(attempt, request_str.size)
        end
      end
    end

    def guess(attempt, indentation)
      marker = Marker.new(attempt, @secret_code)
      @player.puts(' ' * indentation + marker.output)

      win   if marker.success_count == SECRET_LENGTH
      loose if @attempts_count >= ATTEMPTS_COUNT

      @attempts_count += 1
    rescue ArgumentError
      @player.puts "You must enter number with #{SECRET_LENGTH} signs. Try again."
    end

    def loose
      @player.puts "You loose, secret code was #{@secret_code}"
      try_again?
    end

    def win
      @player.puts 'Congratulations, you won!'.bold
      @completed_at = Time.now
      save_score
      try_again?
    end

    def try_again?
      throw :end_play unless @player.yes?('Do you want to try again?')
      @continue_play = false # restart game
    end

    private

    def reset_assets!
      @secret_code = secret_code
      @attempts_count = 0
      @started_at   = nil
      @completed_at = nil
    end

    def secret_code
      Array.new(SECRET_LENGTH) { rand(6) + 1 }.join
    end

    def hint
      @player.puts "The first number is #{@secret_code[0]} =)"
    end

    def save_score
      @store.add_score(@name, @attempts_count, @started_at, @completed_at)
    end

    def show_score
      @player.puts @store.statistic_for(@name)
    end
  end
end
