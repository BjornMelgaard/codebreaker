module Codebreaker
  # controller
  class Game
    ATTEMPTS = 10
    SECRET_LENGTH = 4

    def initialize(attempts = ATTEMPTS, secret_length = SECRET_LENGTH)
      @attempts_left = @attempts_number = attempts

      @secret = Array.new(secret_length) { rand(6) + 1 }.join
      @started_at   = Time.now
      @completed_at = nil
      print @secret
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
      @completed_at = Time.now if marker.success_count == @secret.length
      @attempts_left -= 1
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
      win? || loose?
    end

    def loose?
      @attempts_left <= 0
    end

    def win?
      !@completed_at.nil?
    end
  end
end
