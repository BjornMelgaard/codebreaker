class ScoreManager
  SCORES_PATH = 'scores.yaml'.freeze

  def initialize(player_name)
    @name = player_name
    @scores = load_scores || []
  end

  def save
    save_scores
  end

  def get
    @scores.select { |s| s[:name] == @name }
  end

  def add(statistic)
    score = { name: @name }.merge(statistic)
    @scores.push score
  end

  def statistics
    get.each_with_index.map do |score, index|
      "    Game #{index + 1}: " \
      "attempts - #{score[:attempts_used]}/#{score[:attempts_number]}, " \
      "time - #{score[:time_taken]} seconds"
    end
  end

  private

  def load_scores(path = SCORES_PATH)
    return unless File.exist?(path)
    serialized_scores = File.read(path)
    YAML.load(serialized_scores)
  end

  def save_scores(path = SCORES_PATH)
    serialized = YAML.dump(@scores)
    File.open(path, 'w') { |f| f.write(serialized) }
  end
end
