require_relative '../lib/essence_kernel_genetic_algorithm/team_data.rb'

describe TeamData do

  let(:team_data) { TeamData.new([{'1' => true }, {'2' => true, '3' => true}]) }


  it '#contains?' do
    expect(team_data.contains?(1)).to be true
    expect(team_data.contains?(2)).to be true
    expect(team_data.contains?(3)).to be true
    expect(team_data.contains?(99)).to be false
  end

  it '#before?' do
    expect(team_data.before?(1, 2)).to be true
    expect(team_data.before?(1, 3)).to be true

    expect(team_data.before?(2, 1)).to be false
    expect(team_data.before?(2, 3)).to be false
    expect(team_data.before?(3, 2)).to be false
    expect(team_data.before?(99, 1)).to be false
    expect(team_data.before?(1, 99)).to be false
  end

  it '#meeting_index' do
    expect(team_data.meeting_index(1)).to be 0
    expect(team_data.meeting_index(2)).to be 1
    expect(team_data.meeting_index(3)).to be 1
    expect(team_data.meeting_index(99)).to be nil
  end


end

