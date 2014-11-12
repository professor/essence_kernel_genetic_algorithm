require_relative './individual.rb'
require 'JSON'


kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
individual = Individual.from_json_string(kernel_json_string)

team_id = 26
team_json_string = File.read(File.expand_path("../../../lib/generated_json/team_#{team_id}_deltas.json", __FILE__))
team_json = JSON.parse(team_json_string)

def consider(individual, team_json, checklist_id, meeting_index)
  return 0 if checklist_id < 0
  score = 0
  current_meeting = meeting_index
  while current_meeting < team_json.size
    team_json[meeting_index].keys.each do |checklist|
      continue if checklist.to_i < 0
      score += 1 if individual.before(checklist_id, checklist.to_i)  #Todo fix json generator to not use strings
    end
    current_meeting += 1
  end
  score
end

score = 0
team_json.each_with_index do |meeting, meeting_index|
  meeting.keys.each do |checklist_id|
    score += consider(individual, team_json, checklist_id.to_i, meeting_index)
  end
end

puts score


