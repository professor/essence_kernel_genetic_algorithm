require_relative './individual.rb'
require 'JSON'
class EmpiricalData

  def self.load_team_data(team_ids = [21, 26, 108, 121, 124, 143, 148])
    team_data = {}
    team_ids.each do |team_id|
      team_json_string = File.read(File.expand_path("../../../lib/generated_json/team_#{team_id}_deltas.json", __FILE__))
      team_data[team_id] = JSON.parse(team_json_string)
    end
    team_data
  end

  def self.print_raw_comparison_between(original_score_hash, candidate_score_hash)
    original_score_hash.each do |team_id, score|
      next if team_id == :total
      candidate_score = candidate_score_hash[team_id]
      puts "#{team_id}: #{score} vs #{candidate_score} #{candidate_score > score ? 'BETTER' : ''}"
    end

    team_id = :total
    score = original_score_hash[team_id]
    candidate_score = candidate_score_hash[team_id]
    puts "#{team_id}: #{score} vs #{candidate_score} #{candidate_score > score ? 'BETTER' : ''}"
  end

  def self.asbolute_comparison_header(original_score_hash)
    line = ''
    original_score_hash.each do |team_id, score|
      next if team_id == :total
      line +=  "#{team_id}, "
    end
    line += 'total'
    line
  end

  def self.asbolute_comparison_between(original_score_hash, candidate_score_hash)
    line = ''
    original_score_hash.each do |team_id, score|
      next if team_id == :total
      candidate_score = candidate_score_hash[team_id]
      line +=  "#{candidate_score - score}, "
    end

    total_score = original_score_hash[:total]
    total_candidate_score = candidate_score_hash[:total]
    line += " #{total_candidate_score - total_score} "
    line
  end

  def self.is_candidate_score_better(original_score_hash, candidate_score_hash)
    return original_score_hash[:total] < candidate_score_hash[:total]
  end
end
#
# kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
# individual = Individual.from_json_string(kernel_json_string)
#
# team_data = EmpiricalData.load_team_data
# score_hash = EmpiricalData.evaluate(individual, team_data)
# puts score_hash[:total]
#

