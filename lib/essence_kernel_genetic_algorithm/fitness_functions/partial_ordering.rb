class PartialOrdering

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
      score_hash[id] = score_for_team
      total_score += score_for_team
    end
    score_hash[:total] = total_score
    total_score
    score_hash
  end

end
