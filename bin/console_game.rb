require 'bundler/setup'
require 'codebreaker'
require 'colorize'
require 'yaml'
require_relative 'score_manager'
#
class ConsoleGame
  def start
    print_welcome
    @name = request '    But first, please, enter your name: '
    @scores = ScoreManager.new(@name)
    puts @scores.get.empty? 
         ? "    It's look like you have your first game" 
         : "    Glad to see you again, #{@name.blue}"
    puts "    OK, we can start\n\n"
    run
    puts @scores.statistics if yes?('Can I print your scores?')
    @scores.save
    puts 'See you space, cowboy ヾ(^_^)'.blue
  end

  def run
    catch :stop_game do
      loop do
        @game = Codebreaker::Game.new
        play_game # throw :stop_game when win or loose or exit
        puts "\nGame has been restarted"
      end
    end
  end

  def play_game
    request_str = 'Enter your guess: '
    @identation = request_str.size
    until @game.ended?
      case input = request(request_str)
      when 'hint' then puts "The first number is #{@game.first_number}"
      when 'exit' then throw :stop_game
      when 'restart' then break
      else guess(input)
      end
    end
  end

  def guess(input)
    if @game.code_valid?(input) == false
      puts "You must enter number with #{@game.code_length} signs. Try again."
    else
      marks = colorize_marks @game.guess(input)
      puts ' ' * @identation + marks
      win   if @game.win?
      loose if @game.loose?
    end
  end

  def win
    puts 'Congratulations, you won!'.bold
    @scores.add(@game.statistic)
    try_again?
  end

  def loose
    puts "You loose, secret code was #{@game.secret_code}"
    try_again?
  end

  def try_again?
    throw :stop_game unless yes?('Do you want to try again?')
  end

  private

  def print_welcome
    commands = %w(hint exit restart).map(&:red).join(', ')
    puts %(
    Welcome to #{'Codebreaker'.yellow}.
    Try to guess secret code.
    Also you have available commands at any time: #{commands}.)
  end

  def colorize_marks(marks)
    marks.chars.map do |m|
      case m
      when '+' then m.green
      when '-' then m.red
      else m
      end
    end.join
  end

  def request(msg)
    print(msg)
    gets.chomp
  rescue NoMethodError
    exit
  end

  def yes?(msg)
    request(msg + ' (y/n): ').casecmp('y').zero?
  end
end
