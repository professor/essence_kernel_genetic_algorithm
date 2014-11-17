require_relative '../lib/essence_kernel_genetic_algorithm/simple_algorithm'

describe SimpleAlgorithm do

  let(:kernel_json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(kernel_json_string) }

  xit 'moves every checklist item one state later' do
    subject.systematically_move_checklists_one_state(:later)
  end

  xit 'moves every checklist item one state earlier' do
    subject.systematically_move_checklists_one_state(:earlier)
  end

  it 'moves every checklist item one state later' do
    subject.repeatedly_move_best_checklists_one_state(:later)
  end

end
