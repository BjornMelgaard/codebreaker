module Codebreaker
  class Game
    ATTEMPTS = 10
    SECRET_LENGTH = 4

    attr_reader :attempts_left

    def initialize(attempts = ATTEMPTS, secret_length = SECRET_LENGTH)
      @attempts_left = @attempts_number = attempts

      @secret = generate_secret(secret_length)
      @started_at   = Time.now
      @completed_at = nil
    end

    def code_length
      @secret.length
    end

    def code_valid?(input)
      /^[1-6]{#{code_length}}$/ === input
    end

    def secret_code
      return unless ended?
      @secret
    end

    def guess(input)
      return if ended?
      marker = Marker.new(input, @secret)

      if marker.success_count == code_length
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
      return unless ended?
      time_taken = (@completed_at - @started_at).to_i
      attempts_used = @attempts_number - @attempts_left
      {
        attempts_number: @attempts_number,
        attempts_used: attempts_used,
        time_taken: time_taken
      }
    end

    def ended?
      !@completed_at.nil?
    end

    def loose?
      !@loose.nil?
    end

    def win?
      !@win.nil?
    end

    private

    def generate_secret(length)
      Array.new(length) { rand(6) + 1 }.join
    end
  end
end
