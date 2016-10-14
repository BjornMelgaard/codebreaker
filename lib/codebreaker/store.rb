require 'yaml'

module Codebreaker
  # model
  class Store
    def add_score(_name, _attempts_count, _started_at, _completed_at)
      raise NotImplementedError
    end

    def statistic_for(_name)
      raise NotImplementedError
    end

    def save_scores
      raise NotImplementedError
    end

    def load_scores
      raise NotImplementedError
    end
  end
end
