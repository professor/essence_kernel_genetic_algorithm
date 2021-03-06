require_relative './individual.rb'
require_relative './team_data_collection.rb'
require_relative './team_data.rb'
require 'JSON'
class EmpiricalData

  def self.load_team_data(team_ids = [21, 26, 108, 121, 124])
    team_data = TeamDataCollection.new
    team_ids.each do |team_id|
      team_json_string = File.read(File.expand_path("../../../lib/generated_json/team_#{team_id}_deltas.json", __FILE__))
      team = TeamData.new(JSON.parse(team_json_string))
      team_data.add_team(team_id, team)
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


