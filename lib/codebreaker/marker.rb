module Codebreaker
  # helper
  class Marker
    SUCCESS        = '+'.freeze
    WRONG_POSITION = '-'.freeze
    FAILURE        = ' '.freeze

    attr_reader :success_count

    def initialize(guess, secret)
      guess  = guess.split
      secret = secret.split
      @success_count = 0
      # @marks = FAILURE * secret.lenght
      @marks = Array.new(secret.lenght, FAILURE)

      guess.each_with_index do |g, index|
        secret[index] = nil
        guess[index]  = nil
        @success_count += 1
        @marks[index] = SUCCESS
      end

      guess.each_with_index do |g, index|
        @marks[index] = WRONG_POSITION if g && secret.include?(g)
      end
    end

    def output
      @marks.join
    end
  end
end
