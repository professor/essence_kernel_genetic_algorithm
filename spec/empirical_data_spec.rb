require_relative '../lib/essence_kernel_genetic_algorithm/empirical_data'

describe EmpiricalData do

  let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(kernel_json_string) }

  it 'calculates a total score' do
    team_data = EmpiricalData.load_team_data
    score_hash = EmpiricalData.evaluate(individual, team_data)
    expect(score_hash[:total]).to eq 12973
  end

  it 'calculates a score for each teams dataset' do
    team_data = EmpiricalData.load_team_data
    score_hash = EmpiricalData.evaluate(individual, team_data)
    expect(score_hash[21]).to eq 1238
    expect(score_hash[26]).to eq 2272
    expect(score_hash[108]).to eq 2620
    expect(score_hash[121]).to eq 2152
    expect(score_hash[124]).to eq 3301
    expect(score_hash[143]).to eq 1239
    expect(score_hash[148]).to eq 151
  end

  context '#is_candidate_score_better' do
    let(:original_score_hash) { {part1: 10, part2: 90, total: 100} }

    it 'original is just better' do
      candidate_score_hash = {part1: 5, part2: 5, total: 10}
      result = EmpiricalData.is_candidate_score_better(original_score_hash, candidate_score_hash)
      expect(result).to eq false
    end

    it 'they are tied' do
      result = EmpiricalData.is_candidate_score_better(original_score_hash, original_score_hash)
      expect(result).to eq false
    end

    it 'candidate is just better' do
      candidate_score_hash = {part1: 15, part2: 95, total: 110}
      result = EmpiricalData.is_candidate_score_better(original_score_hash, candidate_score_hash)
      expect(result).to eq true
    end
  end
end
