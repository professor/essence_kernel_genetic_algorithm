require_relative './individual.rb'
require 'JSON'
class EmpiricalData

  def self.load_team_data
    team_data = {}
    team_ids = [21, 26, 108, 121, 124, 143, 148]
    team_ids.each do |team_id|
      team_json_string = File.read(File.expand_path("../../../lib/generated_json/team_#{team_id}_deltas.json", __FILE__))
      team_data[team_id] = JSON.parse(team_json_string)
    end
    team_data
  end

  def self.consider(individual, team_json, checklist_id, meeting_index)
    return 0 if checklist_id < 0
    score = 0
    current_meeting = meeting_index
    while current_meeting < team_json.size
      team_json[meeting_index].keys.each do |checklist|
        next if checklist.to_i < 0
        score += 1 if individual.before(checklist_id, checklist.to_i)  #Todo fix json generator to not use strings
      end
      current_meeting += 1
    end
    score
  end

  def self.evaluate(individual, team_data)
    score_hash = {}
    total_score = 0
    team_data.each do |id, team_json|
      score_for_team = 0
      team_json.each_with_index do |meeting, meeting_index|
        meeting.keys.each do |checklist_id|
          score_for_team += consider(individual, team_json, checklist_id.to_i, meeting_index)
        end
      end
      puts "#{id} => #{score_for_team}"
      score_hash[id] = score_for_team
      total_score += score_for_team
    end
    score_hash[:total] = total_score
    total_score
    score_hash
  end

  def self.print_comparison_between(original_score_hash, candidate_score_hash)
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

