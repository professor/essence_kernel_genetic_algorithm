require_relative './individual.rb'
require_relative './operators.rb'
require_relative './empirical_data.rb'
require_relative './team_data_collection.rb'

require 'pp'

class SimpleAlgorithm

  def systematically_move_checklists_one_state(fitness_class, direction)
    team_data_collection = EmpiricalData.load_team_data

    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)
    original.apply_team_data_meeting_numbers(team_data_collection)

    original_score_hash = fitness_class.evaluate(original, team_data_collection)

    puts "alpha_index, state_index, checklist_index, description, #{EmpiricalData.asbolute_comparison_header(original_score_hash)}"

    #iterate through all checklists
    original.number_of_alphas.times do |alpha_index|
      from = {alpha: alpha_index}

      number_of_states = original.number_of_states(from)
      number_of_states.times do |state_index|
        from = {alpha: alpha_index, state: state_index}

        number_of_checklists = original.number_of_checklists(from)
        number_of_checklists.times do |checklist_index|
          from = {alpha: alpha_index, state: state_index, checklist: checklist_index}

          candidate = original.deep_clone
          checklist_description = candidate.lookup(from)['name']

          Operators.move_checklist_one_state_later(candidate, from) if (direction == :later)
          Operators.move_checklist_one_state_earlier(candidate, from) if (direction == :earlier)

          candidate_score_hash = fitness_class.evaluate(candidate, team_data_collection)

          puts "#{alpha_index}, #{state_index}, #{checklist_index}, \"#{checklist_description}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"

          # if EmpiricalData.is_candidate_score_better(original_score_hash, candidate_score_hash)
          #   candidate.pretty_print
          #   EmpiricalData.print_raw_comparison_between(original_score_hash, candidate_score_hash)
          # end
        end
      end
    end
  end

  def find_best_checklist(fitness_class, starting_individual, team_data_collection)
    original_score_hash = fitness_class.evaluate(starting_individual, team_data_collection)

    best_score_hash = fitness_class.evaluate(starting_individual, team_data_collection)
    best_checklist_location = nil
    best_checklist = nil
    direction = nil
    best_individual = starting_individual.deep_clone

    #iterate through all checklists
    starting_individual.number_of_alphas.times do |alpha_index|
      from = {alpha: alpha_index}

      number_of_states = starting_individual.number_of_states(from)
      number_of_states.times do |state_index|
        from = {alpha: alpha_index, state: state_index}

        number_of_checklists = starting_individual.number_of_checklists(from)
        number_of_checklists.times do |checklist_index|
          from = {alpha: alpha_index, state: state_index, checklist: checklist_index}
          checklist_id = starting_individual.lookup(from)['id']
          checklist_description = starting_individual.lookup(from)['name']

          candidate_later = starting_individual.deep_clone
          Operators.move_checklist_one_state_later(candidate_later, from)
          candidate_later_score_hash = fitness_class.evaluate(candidate_later, team_data_collection)

          candidate_earlier = starting_individual.deep_clone
          Operators.move_checklist_one_state_earlier(candidate_earlier, from)
          candidate_earlier_score_hash = fitness_class.evaluate(candidate_earlier, team_data_collection)

          # puts "#{candidate_later_score_hash[:total]} vs #{original_score_hash[:total]} vs #{candidate_earlier_score_hash[:total]}"

          later_delta = candidate_later_score_hash[:total] - original_score_hash[:total]
          earlier_delta = candidate_earlier_score_hash[:total] - original_score_hash[:total]

          # puts "#{alpha_index}, #{state_index}, #{checklist_index}, \"#{checklist_description}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"

          if later_delta > earlier_delta and later_delta > 0
              if EmpiricalData.is_candidate_score_better(best_score_hash, candidate_later_score_hash)
                direction = :later
                best_score_hash = candidate_later_score_hash
                best_checklist = {id: checklist_id, description: checklist_description}
                best_checklist_location = from
                best_individual = candidate_later.deep_clone
              end
          elsif earlier_delta > later_delta and earlier_delta > 0
            if EmpiricalData.is_candidate_score_better(best_score_hash, candidate_earlier_score_hash)
              direction = :earlier
              best_score_hash = candidate_earlier_score_hash
              best_checklist = {id: checklist_id, description: checklist_description}
              best_checklist_location = from
              best_individual = candidate_earlier.deep_clone
            end
          end
        end
      end
    end
    [best_individual, best_checklist, best_checklist_location, best_score_hash, direction]
  end

  def repeatedly_move_best_checklists_one_state(fitness_class, original, team_data, filename)
    original_score_hash = fitness_class.evaluate(original, team_data)

    candidate = original
    previous_score_hash = original_score_hash
    candidate.pretty_print
    Kernel.loop do
      (candidate, moved_checklist, moved_checklist_location, candidate_score_hash, direction) = find_best_checklist(fitness_class, candidate, team_data)
      if moved_checklist != nil
        puts "#{candidate_score_hash[:total]}, #{direction.to_s}, #{moved_checklist[:id]}, \"#{moved_checklist[:description]}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"
      end

      break if(previous_score_hash[:total] == candidate_score_hash[:total])
      previous_score_hash = candidate_score_hash

      File.write(File.expand_path("../../../generated_kernels/#{filename}_#{fitness_class.to_s.downcase}.json", __FILE__), JSON.pretty_generate(candidate.alphas))
      File.open(File.expand_path("../../../generated_kernels/#{filename}_#{fitness_class.to_s.downcase}.rb", __FILE__), 'w') do |file|
        PP.pp(candidate.alphas, file)
      end
    end

    candidate.pretty_print
  end
end
