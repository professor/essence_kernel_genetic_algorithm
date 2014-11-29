require_relative '../lib/essence_kernel_genetic_algorithm/team_data.rb'

describe TeamData do

  let(:team_data) { TeamData.new([{'1' => true }, {'11' => true, '12' => true}, {'21' => true}]) }


  it '#contains?' do
    expect(team_data.contains?(1)).to be true
    expect(team_data.contains?(11)).to be true
    expect(team_data.contains?(12)).to be true
    expect(team_data.contains?(99)).to be false
  end

  it 'checklists' do
    expect(team_data.checklists).to eq({1 => true, 11 => true, 12 => true, 21 => true})
  end

  context '#strict_before??' do
    it 'works for single ids' do
      expect(team_data.strict_before?(1, 11)).to be true
      expect(team_data.strict_before?(1, 12)).to be true

      expect(team_data.strict_before?(11, 1)).to be false
      expect(team_data.strict_before?(11, 12)).to be false
      expect(team_data.strict_before?(12, 11)).to be false
      expect(team_data.strict_before?(99, 1)).to be false
      expect(team_data.strict_before?(1, 99)).to be false
    end

    it 'works for arrays' do
      expect(team_data.strict_before?([], 1)).to be true
      expect(team_data.strict_before?([], 11)).to be true
      expect(team_data.strict_before?([], 99)).to be false

      expect(team_data.strict_before?([1], 11)).to be true
      expect(team_data.strict_before?([1, 11], 21)).to be true
      expect(team_data.strict_before?([1, 11], 12)).to be false
      expect(team_data.strict_before?([1, 12], 11)).to be false
      expect(team_data.strict_before?([11, 1], 21)).to be true
      expect(team_data.strict_before?([99], 21)).to be false
      expect(team_data.strict_before?([1, 21], 11)).to be false
    end
  end

  context '#before_or_equals?' do
    it 'works for single ids' do
      expect(team_data.before_or_equals?(1, 11)).to be true
      expect(team_data.before_or_equals?(1, 12)).to be true

      expect(team_data.before_or_equals?(11, 1)).to be false
      expect(team_data.before_or_equals?(11, 12)).to be true
      expect(team_data.before_or_equals?(12, 11)).to be true
      expect(team_data.before_or_equals?(99, 1)).to be false
      expect(team_data.before_or_equals?(1, 99)).to be false
    end

    it 'works for arrays' do
      expect(team_data.before_or_equals?([], 1)).to be true
      expect(team_data.before_or_equals?([], 11)).to be true
      expect(team_data.before_or_equals?([], 99)).to be false

      expect(team_data.before_or_equals?([1], 11)).to be true
      expect(team_data.before_or_equals?([1, 11], 21)).to be true
      expect(team_data.before_or_equals?([1, 11], 12)).to be true
      expect(team_data.before_or_equals?([1, 12], 11)).to be true
      expect(team_data.before_or_equals?([11, 1], 21)).to be true
      expect(team_data.before_or_equals?([99], 21)).to be false
      expect(team_data.before_or_equals?([1, 21], 11)).to be false
    end
  end

  it '#meeting_index' do
    expect(team_data.meeting_index(1)).to be 0
    expect(team_data.meeting_index(11)).to be 1
    expect(team_data.meeting_index(12)).to be 1
    expect(team_data.meeting_index(99)).to be nil
  end
end
