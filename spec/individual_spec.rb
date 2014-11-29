require_relative '../lib/essence_kernel_genetic_algorithm/individual.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/empirical_data.rb'
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

  context '#lookup' do
    it 'looks up the correct id' do
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

    context 'looks up the correct length' do
      it 'for the alphas' do
        expect(individual.lookup({alpha: 0})['states'].length).to eq 7
        expect(individual.lookup({alpha: 1})['states'].length).to eq 6
        expect(individual.lookup({alpha: 2})['states'].length).to eq 6
        expect(individual.lookup({alpha: 3})['states'].length).to eq 7
        expect(individual.lookup({alpha: 4})['states'].length).to eq 5
        expect(individual.lookup({alpha: 5})['states'].length).to eq 4
        expect(individual.lookup({alpha: 6})['states'].length).to eq 6
      end

      it 'for the states' do
        expect(individual.lookup({alpha: 0, state: 0})['checklists'].length).to eq 3
        expect(individual.lookup({alpha: 0, state: 1})['checklists'].length).to eq 5
        expect(individual.lookup({alpha: 0, state: 2})['checklists'].length).to eq 3
        expect(individual.lookup({alpha: 0, state: 3})['checklists'].length).to eq 4
        expect(individual.lookup({alpha: 0, state: 4})['checklists'].length).to eq 1
        expect(individual.lookup({alpha: 0, state: 5})['checklists'].length).to eq 1
        expect(individual.lookup({alpha: 0, state: 6})['checklists'].length).to eq 1
        expect(individual.lookup({alpha: 6, state: 0})['checklists'].length).to eq 4
        expect(individual.lookup({alpha: 6, state: 1})['checklists'].length).to eq 8
        expect(individual.lookup({alpha: 6, state: 2})['checklists'].length).to eq 3
        expect(individual.lookup({alpha: 6, state: 3})['checklists'].length).to eq 6
        expect(individual.lookup({alpha: 6, state: 4})['checklists'].length).to eq 2
        expect(individual.lookup({alpha: 6, state: 5})['checklists'].length).to eq 4
      end
    end
  end

  context '#number_of_states' do
    it 'for an alphas, returns the number of states' do
      expect(individual.number_of_states({alpha: 0})).to eq 7
      expect(individual.number_of_states({alpha: 1})).to eq 6
      expect(individual.number_of_states({alpha: 2})).to eq 6
      expect(individual.number_of_states({alpha: 3})).to eq 7
      expect(individual.number_of_states({alpha: 4})).to eq 5
      expect(individual.number_of_states({alpha: 5})).to eq 4
      expect(individual.number_of_states({alpha: 6})).to eq 6
    end

    it 'for anything else, it errors' do
      expect { individual.number_of_states({}) }.to raise_error
      expect { individual.number_of_states({alpha: 0, state: 0}) }.to raise_error
    end
  end

  context '#number_of_checklists' do
    it 'for a state, returns the number of checklists' do
      first_state = {alpha: 0, state: 0}
      expect(individual.number_of_checklists(first_state)).to eq 3

      last_state = {alpha: 0, state: 6}
      expect(individual.number_of_checklists(last_state)).to eq 1

      checklist1 = {alpha: 0, state: 0, checklist: 0}
      expect { individual.number_of_checklists(checklist1) }.to raise_error

      checklist2 = {alpha: 0, state: 0, checklist: 1}
      expect { individual.number_of_checklists(checklist2) }.to raise_error

      checklist3 = {alpha: 0, state: 0, checklist: 2}
      expect { individual.number_of_checklists(checklist3) }.to raise_error
    end
  end

  context '#create_location_hash' do
    it 'works' do
      location_hash = individual.create_location_hash

      expect(location_hash[911]).to eq ({alpha: 0, state: 0})
      expect(location_hash[914]).to eq ({alpha: 0, state: 1})
      expect(location_hash[929]).to eq ({alpha: 1, state: 0})
    end
  end

  context '#before' do
    let(:meetings) {
      {alphas:
        [{states: [{checklists: [{id: 'alpha1_state1a'}, {id: 'alpha1_state1b'}]},
          {checklists: [{id: 'alpha1_state2a'}, {id: 'alpha1_state2b'}]}]},
          {states: [{checklists: [{id: 'alpha2_state1a'}, {id: 'alpha2_state1b'}]},
            {checklists: [{id: 'alpha2_state2a'}, {id: 'alpha2_state2b'}]}]},
        ]
      }
    }
    let(:simple) { Individual.from_json_string(meetings.to_json) }

    it 'two checklist in the same state are not before each other' do
      expect(individual.before(911, 912)).to eq false
      expect(individual.before(912, 911)).to eq false

      expect(simple.before('alpha1_state1a', 'alpha1_state1b')).to eq false
      expect(simple.before('alpha1_state1b', 'alpha1_state1a')).to eq false

    end

    it 'two checklists in different alphas are not not before each other' do
      expect(individual.before(911, 912)).to eq false
      expect(individual.before(912, 911)).to eq false

      expect(simple.before('alpha1_state1a', 'alpha2_state1a')).to eq false
      expect(simple.before('alpha2_state1a', 'alpha1_state1a')).to eq false
    end

    it 'is true for a checklists in a later state' do
      expect(individual.before(911, 914)).to eq true

      expect(simple.before('alpha1_state1a', 'alpha1_state2a')).to eq true
    end

    it 'is false for a checklist in an earlier state' do
      expect(individual.before(914, 911)).to eq false

      expect(simple.before('alpha1_state2a', 'alpha1_state1a')).to eq false
    end
  end

  context '#before_or_equals' do
    let(:meetings) {
      {alphas:
        [{states: [{checklists: [{id: 'alpha1_state1a'}, {id: 'alpha1_state1b'}]},
          {checklists: [{id: 'alpha1_state2a'}, {id: 'alpha1_state2b'}]}]},
          {states: [{checklists: [{id: 'alpha2_state1a'}, {id: 'alpha2_state1b'}]},
            {checklists: [{id: 'alpha2_state2a'}, {id: 'alpha2_state2b'}]}]},
        ]
      }
    }
    let(:simple) { Individual.from_json_string(meetings.to_json) }

    it 'two checklist in the same state are before_or_equals each other' do
      expect(simple.before_or_equals('alpha1_state1a', 'alpha1_state1b')).to eq true
      expect(simple.before_or_equals('alpha1_state1b', 'alpha1_state1a')).to eq true

    end

    it 'two checklists in different alphas are not before_or_equals each other' do
      expect(simple.before_or_equals('alpha1_state1a', 'alpha2_state1a')).to eq false
      expect(simple.before_or_equals('alpha2_state1a', 'alpha1_state1a')).to eq false
    end

    it 'is true for a checklists in a later state' do
      expect(simple.before_or_equals('alpha1_state1a', 'alpha1_state2a')).to eq true
    end

    it 'is false for a checklist in an earlier state' do
      expect(simple.before_or_equals('alpha1_state2a', 'alpha1_state1a')).to eq false
    end
  end

  context '#equals_or_after' do
    let(:meetings) {
      {alphas:
        [{states: [{checklists: [{id: 'alpha1_state1a'}, {id: 'alpha1_state1b'}]},
          {checklists: [{id: 'alpha1_state2a'}, {id: 'alpha1_state2b'}]}]},
          {states: [{checklists: [{id: 'alpha2_state1a'}, {id: 'alpha2_state1b'}]},
            {checklists: [{id: 'alpha2_state2a'}, {id: 'alpha2_state2b'}]}]},
        ]
      }
    }
    let(:simple) { Individual.from_json_string(meetings.to_json) }

    it 'two checklist in the same state are before_or_equals each other' do
      expect(simple.equals_or_after('alpha1_state1a', 'alpha1_state1b')).to eq true
      expect(simple.equals_or_after('alpha1_state1b', 'alpha1_state1a')).to eq true

    end

    it 'two checklists in different alphas are not equals_or_after each other' do
      expect(simple.equals_or_after('alpha1_state1a', 'alpha2_state1a')).to eq false
      expect(simple.equals_or_after('alpha2_state1a', 'alpha1_state1a')).to eq false
    end

    it 'is false for a checklists in a later state' do
      expect(simple.equals_or_after('alpha1_state1a', 'alpha1_state2a')).to eq false
    end

    it 'is true for a checklist in an earlier state' do
      expect(simple.equals_or_after('alpha1_state2a', 'alpha1_state1a')).to eq true
    end
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
    before do
      allow(individual).to receive(:remove_checklist_from_location_hash)
    end

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

    it 'updates location_hash' do
      from = {alpha: 0, state: 0, checklist: 2}
      expect(individual).to receive(:remove_checklist_from_location_hash)

      individual.remove_checklist(from)
    end
  end

  context '#add_checklist' do
    before do
      allow(individual).to receive(:add_checklist_to_location_hash)
    end

    context 'given an alpha, state, and checklist' do
      context 'add checklist item anywhere' do
        it 'to the beginning of an alphas state ' do
          id = 291
          checklist = {'id' => id}
          to = {alpha: 0, state: 1, checklist: 0}
          parent_state = {alpha: 0, state: 1}
          number_checklists = individual.number_of_checklists(parent_state)

          individual.add_checklist(to, checklist)

          expect(individual.lookup(to)['id']).to eq id
          expect(individual.number_of_checklists(parent_state)).to eq number_checklists + 1
        end
      end
    end

    context 'given an alpha and state' do
      context 'add checklist item to end of checklists for that state' do
        it 'to the beginning of an alphas state ' do
          id = 291
          checklist = {'id' => id}
          to_state = {alpha: 0, state: 1}
          number_checklists = individual.number_of_checklists(to_state)

          individual.add_checklist(to_state, checklist)

          expect(individual.number_of_checklists(to_state)).to eq number_checklists + 1
          expect(individual.lookup(to_state)['checklists'].last['id']).to eq id
        end
      end
    end
  end

  it '#total_number_of_checklists' do
    expect(individual.total_number_of_checklists).to eq 147
  end

  context '#remove_state' do
    let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_two_states_one_checklist.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'will remove the state' do
      original_number_of_states = individual.number_of_states({alpha: 0})

      individual.remove_state({alpha: 0, state: 0})
      expect(individual.number_of_states({alpha: 0})).to eq original_number_of_states - 1

      individual.remove_state({alpha: 0, state: 0})
      expect(individual.number_of_states({alpha: 0})).to eq original_number_of_states - 2
    end
  end

  context '#add_checklist' do
    context 'for a state with no checklists' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'you can add a checklist' do
        start = individual.deep_clone

        checklist = individual.remove_checklist({alpha: 0, state: 0, checklist: 0})
        individual.add_checklist({alpha: 0,  state: 0}, checklist)

        expect(individual.alphas).to eq start.alphas
      end
    end

    context 'for an alpha with no states' do
      let(:json_string) { File.read(File.expand_path('../fixtures/one_alpha_one_state_one_checklist.json', __FILE__)) }
      let(:individual) { Individual.from_json_string(json_string) }

      it 'will remove the state' do
        checklist = individual.remove_checklist({alpha: 0, state: 0, checklist: 0})
        individual.remove_state({alpha: 0, state: 0})

        individual.add_checklist({alpha: 0}, checklist)

        expect(individual.number_of_states({alpha: 0})).to eq 1
      end
    end
  end

  context '#apply_team_data_meeting_numbers' do
    let(:json_string) { File.read(File.expand_path('../fixtures/CMU_1.1_work_alpha_only.json', __FILE__)) }
    let(:individual) { Individual.from_json_string(json_string) }

    it 'will add annotations about when the data occurs' do
      team_data = EmpiricalData.load_team_data
      individual.apply_team_data_meeting_numbers(team_data)

      checklist = individual.lookup({alpha: 0, state: 0, checklist: 0})

      # expect(checklist['meetings']).to eq ({21 => 0, 26 => 0, 108 => 0, 121 => 2, 124 => 2 })
      expect(checklist['meetings']).to eq [0, 0, 0, 2, 2 ]
    end

  end

end
