class Completion

  def self.evaluate(individual, team_data_collection)
    score_hash = {}
    total_score = 0

    # individual.number_of_alphas.times do |alpha_index|
    #   from = {alpha: alpha_index}
    #
    #   number_of_states = individual.number_of_states(from)
    #   number_of_states.times do |state_index|
    #     from = {alpha: alpha_index, state: state_index}
    #
    #     number_of_checklists = individual.number_of_checklists(from)
    #     number_of_checklists.times do |checklist_index|
    #       from = {alpha: alpha_index, state: state_index, checklist: checklist_index}
    #
    #       checklist_id = starting_individual.lookup(from)['id']
    #
    #
    #     end
    #   end
    # end

    from = {alpha: 0, state: 0, checklist: 0}
    checklist_id = individual.lookup(from)['id']

    Hash.new
    team_data = team_data_collection.teams.values.first
    total_score += 1 if team_data.contains?(checklist_id)

    score_hash[:total] = total_score
    score_hash
  end

end
