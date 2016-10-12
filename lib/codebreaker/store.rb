require 'yaml'

module Codebreaker
  # model
  class Store
    SCORES_PATH = 'scores.yaml'.freeze

    def initialize
      @scores = []
      load_scores
    end

    def add_score(name, attempts_count, started_at, completed_at)
      time_taken = (completed_at - started_at).to_i
      @scores.push(name: name, attempts_count: attempts_count, time_taken: time_taken)
    end

    def statistic_for(name)
      @scores
        .select { |score| score[:name] == name }
        .each_with_index.map do |score, index|
          "    Game #{index + 1}: " \
          "attempts - #{score[:attempts_count]}, " \
          "time - #{score[:time_taken]} seconds"
        end
    end

    def save_scores
      serialized_scores = YAML.dump(@scores)
      File.open(SCORES_PATH, 'w') { |f| f.write(serialized_scores) }
    end

    def load_scores
      return unless File.exist?(SCORES_PATH)
      serialized_scores = File.read(SCORES_PATH)
      @scores = YAML.load(serialized_scores)
    end
  end
end
