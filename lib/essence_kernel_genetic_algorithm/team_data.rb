class TeamData

  def initialize(ruby)
    @lookup = nil
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

  def strict_before?(checklist_id, second_checklist_id)
    build_lookup if @lookup == nil

    if checklist_id.is_a?(Array)
      return false if @lookup[second_checklist_id] == nil
      return true if checklist_id == []
      #todo: refactor with collect_with_object?
      checklist_id.each do |id|
        return false if @lookup[id] == nil
        return false if @lookup[second_checklist_id] <= @lookup[id]
      end
      return true
    else
      return false if @lookup[checklist_id] == nil or @lookup[second_checklist_id] == nil
      @lookup[checklist_id] < @lookup[second_checklist_id]
    end
  end

  def before_or_equals?(checklist_id, second_checklist_id)
    build_lookup if @lookup == nil

    if checklist_id.is_a?(Array)
      return false if @lookup[second_checklist_id] == nil
      return true if checklist_id == []
      #todo: refactor with collect_with_object?
      checklist_id.each do |id|
        return false if @lookup[id] == nil
        return false if @lookup[second_checklist_id] < @lookup[id]
      end
      return true
    else
      return false if @lookup[checklist_id] == nil or @lookup[second_checklist_id] == nil
      @lookup[checklist_id] <= @lookup[second_checklist_id]
    end
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
