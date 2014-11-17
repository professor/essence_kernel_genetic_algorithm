require_relative './individual.rb'
require_relative './operators.rb'
require_relative './empirical_data.rb'

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
end
