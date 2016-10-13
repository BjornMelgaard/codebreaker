module Codebreaker
  # helper
  class Marker
    # marks
    SUCCESS        = '+'.green.freeze
    WRONG_POSITION = '-'.red.freeze
    FAILURE        = ' '.freeze

    attr_reader :success_count

    def initialize(guess, secret)
      Integer(guess) # can raise ArgumentError
      raise ArgumentError if guess.size != secret.length

      guess  = guess.chars.map(&:to_i)
      secret = secret.chars.map(&:to_i)

      @success_count = 0
      @marks = guess.each_with_index.map do |digit, index|
        if digit == secret[index]
          secret[index] = nil
          @success_count += 1
          SUCCESS
        elsif secret.include?(digit)
          WRONG_POSITION
        else FAILURE
        end
      end
    end

    def output
      @marks.join
    end
  end
end
