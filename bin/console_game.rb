require 'bundler/setup'
require 'codebreaker'
require 'colorize'
#
class ConsoleGame
  SCORES_PATH = 'scores.yaml'.freeze

  def initialize
    commands = %w(hint exit restart).map(&:red).join(', ')
    puts %(
    Welcome to Codebreaker.
    Try to guess secret code.
    Also you have available commands at any time: #{commands}.)

    @name = request '    But first, please, enter your name: '
    @scores = load_scores || []
    puts "    It's look like you have your first game" if @scores.select { |s| s[:name] == @name }.empty?
    puts "    OK, we can start\n\n"
    start
  end

  def start
    @game = Codebreaker::Game.new
    request_str = 'Enter your guess: '
    @identation = request_str.size

    loop do
      puts "@game.ended? = #{@game.ended?}"
      if @game.ended?
        yes?('Do you want to try again?') ? restart_game : break
      end
      input = request(request_str)

      output = case input
               when 'hint' then @game.hint + "\n"
               when 'exit' then break
               when 'restart' then restart_game
               else process(input)
               end
      output ? print(output) : break
    end
    show_score if yes?('Can I print score?')
    save_scores
    puts 'See you space, cowboy ヾ(^_^)'.blue
  end

  def process(input)
    # puts "valid = #{@game.code_valid?(input)}"
    return "You must enter number with #{@game.code_length} signs. Try again.\n" unless @game.code_valid?(input)
    marks = @game.guess(input)
    buffer = ' ' * @identation + marks + "\n"
    if @game.win?
      score = { name: @name }.merge(@game.statistic)
      @scores.push score
      buffer << "Congratulations, you won!\n".bold
    elsif @game.loose?
      buffer << "You loose, secret code was #{@game.secret_code}\n"
    end
    buffer
  end

  def restart_game
    @game = Codebreaker::Game.new
    "Game has been restarted\n"
  end

  private

  def save_scores
    serialized_scores = YAML.dump(@scores)
    File.open(SCORES_PATH, 'w') { |f| f.write(serialized_scores) }
  end

  def load_scores
    return unless File.exist?(SCORES_PATH)
    serialized_scores = File.read(SCORES_PATH)
    YAML.load(serialized_scores)
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
