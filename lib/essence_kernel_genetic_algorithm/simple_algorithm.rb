require_relative './individual.rb'
require_relative './operators.rb'
require_relative './empirical_data.rb'
require 'pp'

class SimpleAlgorithm

  def systematically_move_checklists_one_state(direction)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)

    team_data = EmpiricalData.load_team_data
    original_score_hash = EmpiricalData.evaluate(original, team_data)

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

          candidate = Marshal.load(Marshal.dump(original))
          checklist_description = candidate.lookup(from)['name']

          Operators.move_checklist_one_state_later(candidate, from) if (direction == :later)
          Operators.move_checklist_one_state_earlier(candidate, from) if (direction == :earlier)

          candidate_score_hash = EmpiricalData.evaluate(candidate, team_data)

          puts "#{alpha_index}, #{state_index}, #{checklist_index}, \"#{checklist_description}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"

          # if EmpiricalData.is_candidate_score_better(original_score_hash, candidate_score_hash)
          #   candidate.pretty_print
          #   EmpiricalData.print_raw_comparison_between(original_score_hash, candidate_score_hash)
          # end
        end
      end
    end
  end

  def find_best_checklist(starting_individual, team_data, direction)
    best_score_hash = EmpiricalData.evaluate(starting_individual, team_data)
    best_checklist_location = nil
    best_checklist = nil
    best_individual = Marshal.load(Marshal.dump(starting_individual))

    #iterate through all checklists
    starting_individual.number_of_alphas.times do |alpha_index|
      from = {alpha: alpha_index}

      number_of_states = starting_individual.number_of_states(from)
      number_of_states.times do |state_index|
        from = {alpha: alpha_index, state: state_index}

        number_of_checklists = starting_individual.number_of_checklists(from)
        number_of_checklists.times do |checklist_index|
          from = {alpha: alpha_index, state: state_index, checklist: checklist_index}

          candidate = Marshal.load(Marshal.dump(starting_individual))
          checklist_id = candidate.lookup(from)['id']
          checklist_description = candidate.lookup(from)['name']

          Operators.move_checklist_one_state_later(candidate, from) if (direction == :later)
          Operators.move_checklist_one_state_earlier(candidate, from) if (direction == :earlier)

          candidate_score_hash = EmpiricalData.evaluate(candidate, team_data)

          # puts "#{alpha_index}, #{state_index}, #{checklist_index}, \"#{checklist_description}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"

          if EmpiricalData.is_candidate_score_better(best_score_hash, candidate_score_hash)
            best_score_hash = candidate_score_hash
            best_checklist = {id: checklist_id, description: checklist_description}
            best_checklist_location = from
            best_individual = Marshal.load(Marshal.dump(candidate))
          end
        end
      end
    end
    [best_individual, best_checklist, best_checklist_location, best_score_hash]
  end

  def repeatedly_move_best_checklists_one_state(direction)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)

    team_data = EmpiricalData.load_team_data
    original_score_hash = EmpiricalData.evaluate(original, team_data)

    candidate = original
    previous_score_hash = original_score_hash
    candidate.pretty_print
    Kernel.loop do
      (candidate, moved_checklist, moved_checklist_location, candidate_score_hash) = find_best_checklist(candidate, team_data, direction)
      puts "#{moved_checklist[:id]}, \"#{moved_checklist[:description]}\", #{EmpiricalData.asbolute_comparison_between(original_score_hash, candidate_score_hash)}"

      break if(previous_score_hash[:total] == candidate_score_hash[:total])
      previous_score_hash = candidate_score_hash
    end

    candidate.pretty_print
    File.write(File.expand_path("../../../generated_kernels/repeatedly_move_forward_best_checklists_one_state.json", __FILE__), JSON.pretty_generate(candidate.alphas))
    File.open(File.expand_path("../../../generated_kernels/repeatedly_move_forward_best_checklists_one_state.rb", __FILE__), 'w') do |file|
      PP.pp(candidate.alphas, file)
    end
  end
end
