require 'JSON'

class Individual

  attr_accessor :alphas

  def initialize()

  end

  def index_parts(hash)
    return [hash[:alpha], hash[:state], hash[:checklist]]
  end

  def lookup(hash)
    (alpha, state, checklist) = index_parts(hash)

    if alpha and state and checklist
      alphas[alpha]['states'][state]['checklists'][checklist]
    elsif alpha and state
      alphas[alpha]['states'][state]
    elsif alpha
      alphas[alpha]
    else
      raise 'improper lookup'
    end
  end

  private
  def states_lookup(hash)
    (alpha, state, checklist) = index_parts(hash)

    if alpha and state and checklist
      raise 'improper lookup'
    elsif alpha and state
      raise 'improper lookup'
    elsif alpha
      alphas[alpha]['states']
    else
      raise 'improper lookup'
    end
  end

  def checklists_lookup(hash)
    (alpha, state, checklist) = index_parts(hash)

    if alpha and state and checklist
      raise 'improper lookup'
    elsif alpha and state
      alphas[alpha]['states'][state]['checklists']
    elsif alpha
      raise 'improper lookup'
    else
      raise 'improper lookup'
    end
  end

  public
  def number_of_alphas
    self.alphas.length
  end

  def number_of_states(hash)
    states_lookup(hash).length
  end

  def number_of_checklists(hash)
    checklists_lookup(hash).length
  end

  def create_location_hash
    location_hash = {}
    alphas.each_with_index do |alpha, alpha_index|
      alpha_id = alpha['id']
      alpha['states'].each_with_index do |state, state_index|
        state_id = state['id']
        state['checklists'].each do |checklist|
          checklist_id = checklist['id']
          location_hash[checklist_id] = {alpha: alpha_index, state: state_index}
        end
      end
    end
    @location_hash = location_hash
  end

  def before(checklist_id1, checklist_id2)
    location_1 = @location_hash[checklist_id1]
    location_2 = @location_hash[checklist_id2]
    if location_1[:alpha] == location_2[:alpha]
      if location_1[:state] < location_2[:state]
        return true
      end
    end
    return false
  end

  def self.from_json_string(json_string)
    json = JSON.parse(json_string)

    individual = Individual.new
    individual.alphas = json['alphas']
    individual.create_location_hash
    individual.copy_alpha_properties_to_each_checklist
    individual
  end

  def copy_alpha_properties_to_each_checklist
    alphas.each do |alpha|
      alpha_name = alpha['name']
      alpha_color = alpha['color']
      alpha['states'].each_with_index do |state, index|
        state_name = state['name']
        state['checklists'].each do |checklist|
          checklist['original_alpha_name'] = alpha_name
          checklist['original_alpha_color'] = alpha_color
          checklist['original_state_name'] = state_name
          checklist['original_state_order'] = index
        end
      end
    end
  end

  def remove_checklist_from_location_hash(checklist_index)
    @location_hash.delete(checklist_index)
  end

  def add_checklist_to_location_hash(checklist_id, alpha_index, state_index)
    @location_hash[checklist_id] = {alpha: alpha_index, state: state_index}
  end

  def remove_checklist(from)
    (alpha_index, state_index, checklist_index) = index_parts(from)
    remove_checklist_from_location_hash(checklist_index)

    alphas[alpha_index]['states'][state_index]['checklists'].delete_at(checklist_index)
  end

  def add_checklist(to, checklist)
    (alpha_index, state_index, checklist_index) = index_parts(to)
    add_checklist_to_location_hash(checklist['id'], alpha_index, state_index)

    if(checklist_index == nil)
      alphas[alpha_index]['states'][state_index]['checklists'].push(checklist)
    else
      alphas[alpha_index]['states'][state_index]['checklists'].insert(checklist_index, checklist)
    end
  end

  def remove_state(state_loction)
    (alpha_index, state_index, checklist_index) = index_parts(state_loction)

    alphas[alpha_index]['states'].delete_at(state_index)
  end

  def random_helper(options)
    able_to_insert_at_end = options[:able_to_insert_at_end]
    from = {}

    number_of_alphas = self.number_of_alphas
    alpha_index = Random.rand(number_of_alphas)
    from[:alpha] = alpha_index

    number_of_states = self.number_of_states(from)
    state_index = Random.rand(number_of_states)
    from[:state] = state_index

    number_of_checklists = self.number_of_checklists(from) + able_to_insert_at_end
    checklist_index = Random.rand(number_of_checklists)
    from[:checklist] = checklist_index
    from
  end

  def random_to
    random_helper(able_to_insert_at_end: 1)
  end

  def random_from
    random_helper(able_to_insert_at_end: 0)
  end

  def random_state
    from = {}

    number_of_alphas = self.number_of_alphas
    alpha_index = Random.rand(number_of_alphas)
    from[:alpha] = alpha_index

    number_of_states = self.number_of_states(from)
    state_index = Random.rand(number_of_states)
    from[:state] = state_index
    from
  end

  def total_number_of_checklists
    count = 0

    self.number_of_alphas.times do |alpha_index|
      from = {alpha: alpha_index}
      number_of_states = self.number_of_states(from)

      number_of_states.times do |state_index|
        from = {alpha: alpha_index, state: state_index}
        number_of_checklists = self.number_of_checklists(from)

        number_of_checklists.times do |checklist_index|
          count += 1
        end
      end
    end
    count
  end

  def pretty_print
    puts '-----------------------------------------------------------------------------'
    alphas.each_with_index do |alpha, alpha_index|
      alpha_name = alpha['name']
      alpha_id = alpha['id']

      line = '| %-15.15s ' % alpha_name

      alpha['states'].each_with_index do |state, state_index|
        state_id = state['id']

        number_of_checklists = state['checklists'].length
        line += '| %2.2s ' % number_of_checklists
      end

      line += '|'
      puts line
    end
    puts '-----------------------------------------------------------------------------'
  end
end
