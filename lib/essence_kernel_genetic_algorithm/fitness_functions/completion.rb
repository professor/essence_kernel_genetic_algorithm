class Completion

  def self.evaluate(individual, team_data_collection)
    score_hash = {}
    total_score = 0

    team_data = team_data_collection.teams.values.first

    #iterate
    individual.number_of_alphas.times do |alpha_index|
      from = {alpha: alpha_index}

      earlier_checklist_ids = []
      current_states_checklist_ids = []

      number_of_states = individual.number_of_states(from)
      number_of_states.times do |state_index|
        from = {alpha: alpha_index, state: state_index}

        earlier_checklist_ids.concat current_states_checklist_ids
        current_states_checklist_ids = []

        number_of_checklists = individual.number_of_checklists(from)
        number_of_checklists.times do |checklist_index|
          from = {alpha: alpha_index, state: state_index, checklist: checklist_index}

          current_checklist_id = individual.lookup(from)['id']
          # binding.pry
          total_score += 1 if team_data.contains?(current_checklist_id) and
            team_data.before?(earlier_checklist_ids, current_checklist_id)

          current_states_checklist_ids << current_checklist_id
        end
      end
    end

    score_hash[:total] = total_score
    score_hash
  end

end
