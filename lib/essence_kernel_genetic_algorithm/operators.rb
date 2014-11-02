class Operators

  def self.move_random_checklist_anywhere(individual)
    from = individual.random_from
    checklist = individual.remove_checklist(from)

    to = individual.random_to
    individual.add_checklist(to, checklist)
    individual
  end

  def self.move_random_checklist_one_state_later(individual)
    from = individual.random_from
    puts "*************"
    puts from

    if individual.length({alpha: from[:alpha]}) > from[:state]
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] + 1}
      individual.add_checklist(to, checklist)
    end
    individual
  end

  def self.move_random_checklist_one_state_earlier(individual)
    from = individual.random_from

    if from[:state] > 0
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] - 1}
      individual.add_checklist(to, checklist)
    end
    individual
  end

end
