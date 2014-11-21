class PartialOrdering

  def self.consider(individual, team, checklist_id, meeting_index)
    return 0 if checklist_id < 0
    score = 0
    current_meeting = meeting_index
    while current_meeting < team.meetings.size
      team.json[meeting_index].keys.each do |checklist|
        next if checklist.to_i < 0
        score += 1 if individual.before(checklist_id, checklist.to_i)  #Todo fix json generator to not use strings
      end
      current_meeting += 1
    end
    score
  end

  def self.evaluate(individual, team_data_collection)
    score_hash = {}
    total_score = 0
    team_data_collection.teams.each do |id, team|
      score_for_team = 0
      team.meetings.each_with_index do |meeting, meeting_index|
        meeting.keys.each do |checklist_id|
          score_for_team += consider(individual, team, checklist_id.to_i, meeting_index)
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
