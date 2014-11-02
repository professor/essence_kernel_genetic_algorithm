class Operators

  def self.move_random_checklist_anywhere(individual)
    from = individual.random_from
    checklist = individual.remove_checklist(from)

    to = individual.random_to
    individual.add_checklist(to, checklist)

    # puts "moved #{checklist['id']} from #{from} to #{to}"
    individual
  end

  def self.move_random_checklist_one_state_later(individual)
    from = individual.random_from

    if from[:state] < individual.length({alpha: from[:alpha]}) - 1
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] + 1}
      individual.add_checklist(to, checklist)

      # puts "moved #{checklist['id']} from #{from} to #{to}"
    end
    individual
  end

  def self.move_random_checklist_one_state_earlier(individual)
    from = individual.random_from

    if from[:state] > 0
      checklist = individual.remove_checklist(from)
      to = {alpha: from[:alpha], state: from[:state] - 1}
      individual.add_checklist(to, checklist)

      # puts "moved #{checklist['id']} from #{from} to #{to}"
    end
    individual
  end

end
