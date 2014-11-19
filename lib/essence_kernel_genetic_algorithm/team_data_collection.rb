require_relative './team_data.rb'

class TeamDataCollection

  def initialize
    @team_data = {}
  end

  def add_team(id, data)
    @team_data[id] = data
  end

  def teams
    @team_data
  end

  def self.create_example(team_data_ruby)
    team_data_collection = TeamDataCollection.new
    team_data = TeamData.new(team_data_ruby)
    team_data_collection.add_team(0, team_data)
    team_data_collection
  end
end
