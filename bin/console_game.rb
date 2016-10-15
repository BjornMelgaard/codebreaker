require 'bundler/setup'
require 'codebreaker'
require 'colorize'
require 'yaml'
#
class ConsoleGame
  SCORES_PATH = 'scores.yaml'.freeze

  def initialize
    commands = %w(hint exit restart).map(&:red).join(', ')
    puts %(
    Welcome to #{'Codebreaker'.yellow}.
    Try to guess secret code.
    Also you have available commands at any time: #{commands}.)

    @name = request '    But first, please, enter your name: '
    @scores = load_scores(SCORES_PATH) || []
    if player_scores.empty?
      puts "    It's look like you have your first game"
    else
      puts "    Glad to see you again, #{@name.blue}"
    end
    puts "    OK, we can start\n\n"
    start
    show_player_scores if yes?('Can I print your scores?')
    save_scores(SCORES_PATH)
    puts 'See you space, cowboy ヾ(^_^)'.blue
  end

  def start
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
      when 'hint' then puts @game.hint
      when 'exit' then throw :stop_game
      when 'restart' then break
      else process(input)
      end
    end
  end

  def process(input)
    if @game.code_valid?(input) == false
      puts "You must enter number with #{@game.code_length} signs. Try again."
    else
      marks = colorize_marks @game.guess(input)
      puts ' ' * @identation + marks
      check_game_status
    end
  end

  def check_game_status
    if @game.win?
      puts 'Congratulations, you won!'.bold
      save_score
      try_again?
    elsif @game.loose?
      puts "You loose, secret code was #{@game.secret_code}"
      try_again?
    end
  end

  def try_again?
    throw :stop_game unless yes?('Do you want to try again?')
  end

  private

  def save_scores(path)
    serialized = YAML.dump(@scores)
    File.open(path, 'w') { |f| f.write(serialized) }
  end

  def load_scores(path)
    return unless File.exist?(path)
    serialized_scores = File.read(path)
    YAML.load(serialized_scores)
  end

  def player_scores
    @scores.select { |s| s[:name] == @name }
  end

  def save_score
    score = { name: @name }.merge(@game.statistic)
    @scores.push score
  end

  def show_player_scores
    player_scores.each_with_index.map do |score, index|
      puts "    Game #{index + 1}: " \
           "attempts - #{score[:attempts_used]}/#{score[:attempts_number]}, " \
           "time - #{score[:time_taken]} seconds"
    end
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
