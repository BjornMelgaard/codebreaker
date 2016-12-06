module Codebreaker
  class Marker
    SUCCESS        = '+'.freeze
    WRONG_POSITION = '-'.freeze
    FAILURE        = ' '.freeze

    attr_reader :success_count

    def initialize(guess, secret)
      guesses = guess.chars
      secrets = secret.chars
      @success_count = 0
      @marks = Array.new(secret.length, FAILURE)

      guesses.zip(secrets).each_with_index do |(g, s), index|
        next if g != s

        secrets[index] = nil
        guesses[index] = nil
        @success_count += 1
        @marks[index] = SUCCESS
      end

      guesses.each_with_index do |g, index|
        position = g && secrets.index(g)
        next unless position

        secrets[position] = nil
        @marks[index] = WRONG_POSITION
      end
    end

    def output
      @marks.join
    end
  end
end
