require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/completion'
require_relative '../lib/essence_kernel_genetic_algorithm/individual'
require_relative '../lib/essence_kernel_genetic_algorithm/team_data_collection'

describe Completion do

  context '#evaluate' do
    context 'trivial case of one state with one checklist' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 1
      end

      it 'does not match data' do
        team_data = TeamDataCollection.create_example([{'99' => true }])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 0
      end
    end

    context 'two states with one checklist each' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_two_states_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end

      it 'incorrect order of states' do
        team_data = TeamDataCollection.create_example([{'2' => true }, {'1' => true}])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 1
      end
    end

    context 'two states in different alphas with one checklist each' do
      let(:json_string) { File.read(File.expand_path('../fixtures/two_alphas_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end
    end

    context 'one alpha with one state with two checklists' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_two_checklists.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end
    end

    context 'one alpha with two states with two checklists' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_two_states_two_checklists.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches sequential data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}, {'11' => true}, {'12' => true} ])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 4
      end

      it 'matches data when data happens during same week' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true, '11' => true}, {'12' => true} ])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 3  #or 4 depending upon definitions
      end

      it 'matches data when happens all at the same time' do
        team_data = TeamDataCollection.create_example([{'1' => true, '2' => true, '11' => true, '12' => true} ])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2 #or 4 if we count them all happening at the same time.
      end

      it 'incomplete states only scores items in first state' do
        team_data = TeamDataCollection.create_example([{'1' => true}, {'11' => true}, {'12' => true} ])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 1
      end

      it 'swapped states only scores items in first state' do
        team_data = TeamDataCollection.create_example([{'11' => true}, {'12' => true}, {'1' => true}, {'2' => true} ])
        score_hash = Completion.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end
    end
  end
end
