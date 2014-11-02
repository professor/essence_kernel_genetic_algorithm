require_relative '../lib/essence_kernel_genetic_algorithm/individual.rb'
require 'JSON'

describe Individual do

  let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__)) }
  let(:individual) { Individual.from_json_string(json_string) }

  it 'can load CMU1.1 kernel from disk' do
    alphas = individual.alphas

    expect(alphas.length).to eq 7
    expect(alphas[0]['states'].length).to eq 7
    expect(alphas[1]['states'].length).to eq 6
    expect(alphas[2]['states'].length).to eq 6
    expect(alphas[3]['states'].length).to eq 7
    expect(alphas[4]['states'].length).to eq 5
    expect(alphas[5]['states'].length).to eq 4
    expect(alphas[6]['states'].length).to eq 6
  end

  it 'lookup' do
    first_alpha = {alpha: 0}
    expect(individual.lookup(first_alpha)['id']).to eq 36

    last_alpha = {alpha: 6}
    expect(individual.lookup(last_alpha)['id']).to eq 42

    first_state = {alpha: 0, state: 0}
    expect(individual.lookup(first_state)['id']).to eq 251

    last_state = {alpha: 0, state: 6}
    expect(individual.lookup(last_state)['id']).to eq 257

    checklist1 = {alpha: 0, state: 0, checklist: 0}
    expect(individual.lookup(checklist1)['id']).to eq 911

    checklist2 = {alpha: 0, state: 0, checklist: 1}
    expect(individual.lookup(checklist2)['id']).to eq 912

    checklist3 = {alpha: 0, state: 0, checklist: 2}
    expect(individual.lookup(checklist3)['id']).to eq 913
  end

  it '#length' do
    # individual = {}
    # expect(individual.length(individual)).to eq 7

    first_alpha = {alpha: 0}
    expect(individual.length(first_alpha)).to eq 7

    last_alpha = {alpha: 6}
    expect(individual.length(last_alpha)).to eq 6

    first_state = {alpha: 0, state: 0}
    expect(individual.length(first_state)).to eq 3

    last_state = {alpha: 0, state: 6}
    expect(individual.length(last_state)).to eq 1

    checklist1 = {alpha: 0, state: 0, checklist: 0}
    expect { individual.length(checklist1) }.to raise_error

    checklist2 = {alpha: 0, state: 0, checklist: 1}
    expect { individual.length(checklist2) }.to raise_error

    checklist3 = {alpha: 0, state: 0, checklist: 2}
    expect { individual.length(checklist3) }.to raise_error
  end


  it 'copies name and color to checklists' do
    alphas = individual.alphas

    alpha_name = alphas[0]['name']
    alpha_color = alphas[0]['color']

    checklist_index = {alpha: 0, state: 0, checklist: 0}
    checklist = individual.lookup(checklist_index)

    expect(checklist['original_alpha_name']).to eq alpha_name
    expect(checklist['original_alpha_color']).to eq alpha_color

    state_name = alphas[0]['states'][0]['name']

    expect(checklist['original_state_name']).to eq state_name
    expect(checklist['original_state_order']).to eq 0
  end

  context 'remove a checklist item' do
    it 'from an alphas state with three checklists ' do
      from = {alpha: 0, state: 0, checklist: 2}
      id = individual.lookup(from)['id']
      parent_state = {alpha: 0, state: 0}
      number_checklists_for_parent_state = individual.lookup(parent_state)['checklists'].length

      checklist = individual.remove_checklist(from)

      expect(checklist['id']).to eq id
      expect(individual.lookup(parent_state)['checklists'].length).to eq number_checklists_for_parent_state - 1
    end

  it 'from an alphas state with one checklists keeps the state' do
      from = {alpha: 0, state: 6, checklist: 0}
      id = individual.lookup(from)['id']
      parent_state = {alpha: 0, state: 6}
      expect(individual.lookup(parent_state)['checklists'].length).to eq 1

      checklist = individual.remove_checklist(from)

      expect(checklist['id']).to eq id
      expect(individual.lookup(parent_state)['checklists'].length).to eq 0
    end
  end

  context '#add_checklist' do
    context 'given an alpha, state, and checklist' do
      context 'add checklist item anywhere' do
        it 'to the beginning of an alphas state ' do
        id = 291
        checklist = {'id' => id}
        to   = {alpha: 0, state: 1, checklist: 0}
        parent_state = {alpha: 0, state: 1}
        number_checklists = individual.lookup(parent_state)['checklists'].length

        individual.add_checklist(to, checklist)

        expect(individual.lookup(to)['id']).to eq id
        expect(individual.lookup(parent_state)['checklists'].length).to eq number_checklists + 1
      end
      end
    end

    context 'given an alpha and state' do
      context 'add checklist item to end of checklists for that state' do
        it 'to the beginning of an alphas state ' do
          id = 291
          checklist = {'id' => id}
          to_state = {alpha: 0, state: 1}
          number_checklists = individual.lookup(to_state)['checklists'].length

          individual.add_checklist(to_state, checklist)

          expect(individual.lookup(to_state)['checklists'].length).to eq number_checklists + 1
          expect(individual.lookup(to_state)['checklists'].last['id']).to eq id
        end
      end
    end
  end
end
