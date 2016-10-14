require 'colorize'

module Codebreaker
  # controller
  class Game
    ATTEMPTS_COUNT = 10
    SECRET_LENGTH = 4

    def initialize(ui, store)
      @ui = ui
      @store = store
    end

    def start
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

    def play
      @started_at = Time.now
      @continue_play = true
      request_str = 'Enter your guess: '
      while @continue_play
        case attempt = @ui.request(request_str)
        when 'hint' then hint
        when 'exit' then throw :end_play
        when 'restart' then @continue_play = false
        else guess(attempt, request_str.size)
        end
      end
    end

    def guess(attempt, indentation)
      marker = Marker.new(attempt, @secret_code)
      @ui.puts(' ' * indentation + marker.output)

      win   if marker.success_count == SECRET_LENGTH
      loose if @attempts_count >= ATTEMPTS_COUNT

      @attempts_count += 1
    rescue ArgumentError
      @ui.puts "You must enter number with #{SECRET_LENGTH} signs. Try again."
    end

    def loose
      @ui.puts "You loose, secret code was #{@secret_code}"
      try_again?
    end

    def win
      @ui.puts 'Congratulations, you won!'.bold
      @completed_at = Time.now
      save_score
      try_again?
    end

    def try_again?
      throw :end_play unless @ui.yes?('Do you want to try again?')
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
      @ui.puts "The first number is #{@secret_code[0]} =)"
    end

    def save_score
      @store.add_score(@name, @attempts_count, @started_at, @completed_at)
    end

    def show_score
      @ui.puts @store.statistic_for(@name)
    end
  end
end
