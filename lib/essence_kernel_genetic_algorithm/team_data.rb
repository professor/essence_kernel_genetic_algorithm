class TeamData

  def initialize(json)
    @array_of_hashes = json
  end

  def json
    @array_of_hashes
  end

  def contains?(checklist_id)
    @array_of_hashes.first.keys.include?(checklist_id.to_s)  #Todo fix json generator to not use strings
  end
end
