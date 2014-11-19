class TeamData



  def initialize
    @team_data = {}
  end

  def add_team(id, data)
    @team_data[id] = data
  end

  def data
    @team_data
  end



end
