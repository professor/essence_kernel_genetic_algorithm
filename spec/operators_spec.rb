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

  context '#move_checklist_one_state_later' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'normal case' do
      from = {alpha: 0, state:0, checklist: 0}
      from_number_of_checklists = individual.length({alpha:0, state: 0})
      to_number_of_checklists = individual.length({alpha:0, state: 1})
      id = individual.lookup(from)['id']

      Operators.move_checklist_one_state_later(individual, from)

      expect(individual.length({alpha:0, state: 0})).to eq from_number_of_checklists - 1
      expect(individual.length({alpha:0, state: 1})).to eq to_number_of_checklists + 1
      expect(individual.lookup({alpha:0, state: 0})['checklists'].any? { |c| c['id'] == id}).to eq false
      expect(individual.lookup({alpha:0, state: 1})['checklists'].any? { |c| c['id'] == id}).to eq true
    end

    it 'does nothing for last state in alpha' do
      state_index = individual.length({alpha: 0}) - 1
      from = {alpha: 0, state: state_index, checklist: 0}
      from_number_of_checklists = individual.length({alpha:0, state: state_index})
      id = individual.lookup(from)['id']

      Operators.move_checklist_one_state_later(individual, from)

      expect(individual.length({alpha:0, state: state_index})).to eq from_number_of_checklists
      expect(individual.lookup({alpha:0, state: state_index})['checklists'].any? { |c| c['id'] == id}).to eq true
    end
  end
end
