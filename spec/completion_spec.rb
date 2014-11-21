require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/completion'
require_relative '../lib/essence_kernel_genetic_algorithm/individual'
require_relative '../lib/essence_kernel_genetic_algorithm/team_data_collection'

describe Completion do

  context '#evaluate' do
    let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_one_checklist_each.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'works with trivial case' do
      team_data = TeamDataCollection.create_example([{'1' => true }])
      score_hash = Completion.evaluate(individual, team_data)

      expect(score_hash[:total]).to eq 1
    end

    it 'works with trivial case' do
      team_data = TeamDataCollection.create_example([{'99' => true }])
      score_hash = Completion.evaluate(individual, team_data)

      expect(score_hash[:total]).to eq 0
    end

  end
end
