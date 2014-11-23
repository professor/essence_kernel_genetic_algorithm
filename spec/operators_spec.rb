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
      from_number_of_checklists = individual.number_of_checklists({alpha:0, state: 0})
      to_number_of_checklists = individual.number_of_checklists({alpha:0, state: 1})
      id = individual.lookup(from)['id']

      Operators.move_checklist_one_state_later(individual, from)

      expect(individual.number_of_checklists({alpha:0, state: 0})).to eq from_number_of_checklists - 1
      expect(individual.number_of_checklists({alpha:0, state: 1})).to eq to_number_of_checklists + 1
      expect(individual.lookup({alpha:0, state: 0})['checklists'].any? { |c| c['id'] == id}).to eq false
      expect(individual.lookup({alpha:0, state: 1})['checklists'].any? { |c| c['id'] == id}).to eq true
    end

    it 'does nothing for last state in alpha' do
      state_index = individual.number_of_states({alpha: 0}) - 1
      from = {alpha: 0, state: state_index, checklist: 0}
      from_number_of_checklists = individual.number_of_checklists({alpha:0, state: state_index})
      id = individual.lookup(from)['id']

      Operators.move_checklist_one_state_later(individual, from)

      expect(individual.number_of_checklists({alpha:0, state: state_index})).to eq from_number_of_checklists
      expect(individual.lookup({alpha:0, state: state_index})['checklists'].any? { |c| c['id'] == id}).to eq true
    end
  end

  context '#delete_state' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1_work_alpha_only.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'works' do
      delete_state = {alpha: 0, state: 4}
      total_number_of_checklists = individual.total_number_of_checklists
      number_of_checklists_3 = individual.number_of_checklists({alpha:0, state: 3})
      number_of_checklists_4 = individual.number_of_checklists({alpha:0, state: 4})
      number_of_checklists_5 = individual.number_of_checklists({alpha:0, state: 5})

      allow(individual).to receive(:random_to).and_return({alpha: 0, state: 5})

      Operators.delete_state(individual, delete_state)

      expect(individual.total_number_of_checklists).to eq total_number_of_checklists
      expect(individual.number_of_checklists({alpha:0, state: 3})).to eq number_of_checklists_3
      expect(individual.number_of_checklists({alpha:0, state: 4})).to eq number_of_checklists_4 + number_of_checklists_5
    end
  end

  context '#split_state' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1_work_alpha_only.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'works' do
      split_state = {alpha: 0, state: 1}
      total_number_of_checklists = individual.total_number_of_checklists
      number_of_checklists_0 = individual.number_of_checklists({alpha:0, state: 0})
      number_of_checklists_1 = individual.number_of_checklists({alpha:0, state: 1})
      number_of_checklists_2 = individual.number_of_checklists({alpha:0, state: 2})

      Operators.split_state(individual, split_state)

      expect(individual.total_number_of_checklists).to eq total_number_of_checklists
      expect(individual.number_of_checklists({alpha:0, state: 0})).to eq number_of_checklists_0
      expect(individual.number_of_checklists({alpha:0, state: 1})).to eq number_of_checklists_1 / 2
      expect(individual.number_of_checklists({alpha:0, state: 2})).to eq number_of_checklists_1 / 2 + number_of_checklists_1 % 2
      expect(individual.number_of_checklists({alpha:0, state: 3})).to eq number_of_checklists_2
    end
  end

  context '#split_random_state' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1_work_alpha_only.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'works' do
      total_number_of_checklists = individual.total_number_of_checklists
      number_of_states = individual.number_of_states({alpha:0})

      Operators.split_random_state(individual)

      expect(individual.total_number_of_checklists).to eq total_number_of_checklists
      expect(individual.number_of_states({alpha:0})).to eq number_of_states + 1
    end
  end
end
