require_relative '../lib/essence_kernel_genetic_algorithm/individual.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/operators.rb'
require 'JSON'

describe Operators do

  # context 'randomly moves a checklist item' do
  #   it 'by randomly selecting an alpha and randomly selecting a state' do
  #     from = individual.random_from
  #     checklist = individual.remove_checklist(from)
  #
  #     to = individual.random_to
  #     individual.add_checklist(to, checklist)
  #   end
  # end

  context '#move_random_checklist_one_state_later' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'workes' do
      from = {alpha: 0, state:0, checklist: 0}
      allow(individual).to receive(:random_from).and_return(from)
      from_number_of_checklists = individual.length({alpha:0, state: 0})
      to_number_of_checklists = individual.length({alpha:0, state: 1})
      id = individual.lookup(from)['id']

      Operators.move_random_checklist_one_state_later(individual)

      expect(individual.length({alpha:0, state: 0})).to eq (from_number_of_checklists - 1)
      expect(individual.length({alpha:0, state: 1})).to eq to_number_of_checklists + 1
      expect(individual.lookup({alpha:0, state: 0})['checklists'].any? { |c| c['id'] == id}).to eq false
      expect(individual.lookup({alpha:0, state: 1})['checklists'].any? { |c| c['id'] == id}).to eq true
    end

  end


end
