class PartialOrdering

  def self.score_before_or_equals(individual, checklist_id, later_checklist_ids)
    score = 0
    later_checklist_ids.each_key do |id|
      score += 1 if id != checklist_id && individual.before_or_equals(checklist_id.to_i, id.to_i)
    end
    score
  end

  def self.score_equals_or_after(individual, earlier_checklist_ids, checklist_id)
    score = 0
    earlier_checklist_ids.each_key do |id|
      score += 1 if id != checklist_id && individual.equals_or_after(checklist_id.to_i, id.to_i)
    end
    score
  end

  def self.score_one_team_data(individual, team_data)
    score = 0

    earlier_checklist_ids = {}
    later_checklist_ids = team_data.checklists.clone

    team_data.meetings.each do |meeting|
      meeting.keys.each do |checklist_id_string|
        checklist_id = checklist_id_string.to_i
        score += score_before_or_equals(individual, checklist_id, later_checklist_ids)
        score += score_equals_or_after(individual, earlier_checklist_ids, checklist_id)

        earlier_checklist_ids[checklist_id] = true
        later_checklist_ids.delete(checklist_id)
      end
    end
    score
  end

  public
  def self.evaluate(individual, team_data_collection)
    score_hash = {}
    total_score = 0
    team_data_collection.teams.each do |id, team|
      score_for_team = score_one_team_data(individual, team)
      score_hash[id] = score_for_team
      total_score += score_for_team
    end
    score_hash[:total] = total_score
    score_hash
  end

end
