class TeamData

  def initialize(ruby)
    @array_of_hashes = ruby
  end

  def meetings
    @array_of_hashes
  end

  def meeting_index(checklist_id)
    build_lookup if @lookup == nil
    @lookup[checklist_id]
  end

  def contains?(checklist_id)
    build_lookup if @lookup == nil
    @lookup[checklist_id] != nil
  end

  def before?(checklist_id, second_checklist_id)
    build_lookup if @lookup == nil
    return false if @lookup[checklist_id] == nil or @lookup[second_checklist_id] == nil
    @lookup[checklist_id] < @lookup[second_checklist_id]
  end

  private
  def build_lookup
    @lookup = {}
    self.meetings.each_with_index do |meeting, meeting_index|
      meeting.keys.each do |checklist_id|
        @lookup[checklist_id.to_i] = meeting_index  #Todo fix json generator to not use strings
      end
    end
  end
end
