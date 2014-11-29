require_relative '../lib/essence_kernel_genetic_algorithm/empirical_data'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering'

describe PartialOrdering do

  let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(kernel_json_string) }

  it 'calculates a total score' do
    team_data = EmpiricalData.load_team_data
    score_hash = PartialOrdering.evaluate(individual, team_data)
    expect(score_hash[:total]).to eq 13372
  end

  it 'calculates a score for each teams dataset' do
    team_data = EmpiricalData.load_team_data
    score_hash = PartialOrdering.evaluate(individual, team_data)
    expect(score_hash[21]).to eq 2430
    expect(score_hash[26]).to eq 2794
    expect(score_hash[108]).to eq 2676
    expect(score_hash[121]).to eq 2724
    expect(score_hash[124]).to eq 2748
  end

  context '#evaluate' do
    context 'trivial case of one state with one checklist' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 0 #there is no relationship with anything else
      end

      it 'does not match data' do
        team_data = TeamDataCollection.create_example([{'99' => true }])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 0
      end
    end

    context 'two states with one checklist each' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_two_states_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end

      it 'incorrect order of states' do
        team_data = TeamDataCollection.create_example([{'2' => true }, {'1' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 0
      end
    end

    context 'two states in different alphas with one checklist each' do
      let(:json_string) { File.read(File.expand_path('../fixtures/two_alphas_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 0
      end
    end

    context 'one alpha with one state with two checklists' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_two_checklists.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'1' => true, '2' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end

      it 'matches data' do
        team_data = TeamDataCollection.create_example([{'2' => true, '1' => true}])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq 2
      end
    end

    context 'one alpha with two states with two checklists' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_two_states_two_checklists.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'matches sequential data' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true}, {'11' => true}, {'12' => true} ])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq (4 * 3)
      end

      it 'matches data when data happens during same week' do
        team_data = TeamDataCollection.create_example([{'1' => true }, {'2' => true, '11' => true}, {'12' => true} ])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq (4 * 3)
      end

      it 'matches data when happens all at the same time' do
        team_data = TeamDataCollection.create_example([{'1' => true, '2' => true, '11' => true, '12' => true} ])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq  (4 * 3)
      end

      it 'incomplete states only scores items in first state' do
        team_data = TeamDataCollection.create_example([{'1' => true}, {'11' => true}, {'12' => true} ])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq (3 * 2)
      end

      it 'swapped states only scores items in first state' do
        team_data = TeamDataCollection.create_example([{'11' => true}, {'12' => true}, {'1' => true}, {'2' => true} ])
        score_hash = PartialOrdering.evaluate(individual, team_data)

        expect(score_hash[:total]).to eq (2 + 2)
      end
    end
  end
end
