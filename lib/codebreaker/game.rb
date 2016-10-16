module Codebreaker
  # controller
  class Game
    ATTEMPTS = 10
    SECRET_LENGTH = 4

    attr_reader :attempts_left

    def initialize(attempts = ATTEMPTS, secret_length = SECRET_LENGTH)
      @attempts_left = @attempts_number = attempts

      @secret = Array.new(secret_length) { rand(6) + 1 }.join
      @started_at   = Time.now
      @completed_at = nil
    end

    def code_valid?(input)
      Integer(input) # can raise ArgumentError
      input.size == @secret.length
    rescue ArgumentError
      false
    end

    def code_length
      @secret.length
    end

    def secret_code
      return unless ended?
      @secret
    end

    def guess(input)
      return if ended?
      marker = Marker.new(input, @secret)

      if marker.success_count == @secret.length
        # win
        @win = true
        @completed_at = Time.now
      elsif @attempts_left <= 0
        # loose
        @loose = true
        @completed_at = Time.now
      else
        @attempts_left -= 1
      end

      marker.output
    end

    def first_number
      @secret[0]
    end

    def statistic
      time_taken = (@completed_at - @started_at).to_i
      attempts_used = @attempts_number - @attempts_left
      { attempts_number: @attempts_number, attempts_used: attempts_used, time_taken: time_taken }
    end

    def ended?
      @completed_at != nil
    end

    def loose?
      @loose != nil
    end

    def win?
      @win != nil
    end
  end
end
