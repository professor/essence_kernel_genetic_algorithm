require_relative '../lib/essence_kernel_genetic_algorithm/simple_algorithm'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/completion'

describe SimpleAlgorithm do

  context 'CMU1.1 kernel plus all team_data' do
    let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(kernel_json_string) }
    let(:team_data) { EmpiricalData.load_team_data }


    context 'PartialOrdering' do
      xit 'moves every checklist item one state later' do
        subject.systematically_move_checklists_one_state(PartialOrdering, :later)
      end
      xit 'moves every checklist item one state later' do
        subject.systematically_move_checklists_one_state(Completion, :later)
      end

      xit 'moves every checklist item one state earlier' do
        subject.systematically_move_checklists_one_state(PartialOrdering, :earlier)
      end
      xit 'moves every checklist item one state earlier' do
        subject.systematically_move_checklists_one_state(Completion, :earlier)
      end

      xit 'moves every checklist item one state later' do
        subject.repeatedly_move_best_checklists_one_state(PartialOrdering, individual, team_data, 'repeatedly_move_best_checklists')
      end

      xit 'moves every checklist item one state later' do
        subject.repeatedly_move_best_checklists_one_state(Completion, individual, team_data, 'repeatedly_move_best_checklists')
      end
    end
  end

  context 'just work alpha' do
    let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1_work_alpha_only.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(kernel_json_string) }

    it 'works with work alpha and team 21 data' do
      team_data = EmpiricalData.load_team_data(['21_only_work_alpha'])

      subject.repeatedly_move_best_checklists_one_state(PartialOrdering, individual, team_data, 'repeatedly_move_best_checklists_only_work_alpha_for_team_21')
    end

    it 'works with work alpha and team 21 data' do
      team_data = EmpiricalData.load_team_data(['21_only_work_alpha'])

      subject.repeatedly_move_best_checklists_one_state(Completion, individual, team_data, 'repeatedly_move_best_checklists_only_work_alpha_for_team_21')
    end
  end

end
