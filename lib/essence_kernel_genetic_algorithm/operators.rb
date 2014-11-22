class Operators

  def self.move_random_checklist_anywhere(individual)
    from = individual.random_from
    checklist = individual.remove_checklist(from)

    to = individual.random_to
    individual.add_checklist(to, checklist)

    # puts "moved #{checklist['id']} from #{from} to #{to}"
    individual
  end

  def self.move_checklist_one_state_later(individual, from)
    if from[:state] < individual.number_of_states({alpha: from[:alpha]}) - 1
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] + 1}
      individual.add_checklist(to, checklist)

      # puts "moved #{checklist['id']} from #{from} to #{to}"
    end
    individual
  end

  def self.move_random_checklist_one_state_later(individual)
    from = individual.random_from
    move_checklist_one_state_later(individual, from)
  end

  def self.move_checklist_one_state_earlier(individual, from)
    if from[:state] > 0
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] - 1}
      individual.add_checklist(to, checklist)

      # puts "moved #{checklist['id']} from #{from} to #{to}"
    end
    individual
  end

  def self.move_random_checklist_one_state_earlier(individual)
    from = individual.random_from
    move_checklist_one_state_earlier(individual, from)
  end

  def self.delete_state(individual, delete_state)
    number_of_checklists = individual.number_of_checklists(delete_state)
    while number_of_checklists > 0
      from = delete_state.merge({checklist: number_of_checklists - 1})
      checklist = individual.remove_checklist(from)

      to = individual.random_to
      individual.add_checklist(to, checklist)

      number_of_checklists = individual.number_of_checklists(delete_state)
    end

    individual.remove_state(delete_state)
    # puts "deleted state #{delete_state}"
    individual
  end

  def self.delete_random_state(individual)
    delete_state = individual.random_state
    delete_state(individual, delete_state)
  end
end
