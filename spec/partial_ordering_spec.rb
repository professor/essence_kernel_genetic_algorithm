require_relative '../lib/essence_kernel_genetic_algorithm/empirical_data'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering'

describe PartialOrdering do

  let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(kernel_json_string) }

  it 'calculates a total score' do
    team_data = EmpiricalData.load_team_data
    score_hash = PartialOrdering.evaluate(individual, team_data)
    expect(score_hash[:total]).to eq 12973
  end

  it 'calculates a score for each teams dataset' do
    team_data = EmpiricalData.load_team_data
    score_hash = PartialOrdering.evaluate(individual, team_data)
    expect(score_hash[21]).to eq 1238
    expect(score_hash[26]).to eq 2272
    expect(score_hash[108]).to eq 2620
    expect(score_hash[121]).to eq 2152
    expect(score_hash[124]).to eq 3301
    expect(score_hash[143]).to eq 1239
    expect(score_hash[148]).to eq 151
  end
end
