require_relative '../lib/essence_kernel_genetic_algorithm/empirical_data'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering'

describe EmpiricalData do

  let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(kernel_json_string) }

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
