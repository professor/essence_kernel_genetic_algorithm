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

  def length(hash)
    (alpha, state, checklist) = index_parts(hash)

    if alpha and state and checklist
      raise 'improper length'
    elsif alpha and state
      alphas[alpha]['states'][state]['checklists'].length
    elsif alpha
      alphas[alpha]['states'].length
    else
      alphas.length
    end
  end

  def self.from_json_string(json_string)
    json = JSON.parse(json_string)

    individual = Individual.new
    individual.alphas = json['alphas']
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

  def remove_checklist(from)
    (alpha_index, state_index, checklist_index) = index_parts(from)

    alphas[alpha_index]['states'][state_index]['checklists'].delete_at(checklist_index)
  end

  def add_checklist(to, checklist)
    (alpha_index, state_index, checklist_index) = index_parts(to)

    if(checklist_index == nil)
      alphas[alpha_index]['states'][state_index]['checklists'].push(checklist)
    else
      alphas[alpha_index]['states'][state_index]['checklists'].insert(checklist_index, checklist)
    end
  end

  def random_helper(options)
    able_to_insert_at_end = options[:able_to_insert_at_end]
    from = {}

    number_alphas = self.alphas.length
    alpha_index = Random.rand(number_alphas)
    from[:alpha] = alpha_index

    number_of_states = self.lookup(from).length
    state_index = Random.rand(number_of_states)
    from[:state] = state_index

    number_of_checklists = self.lookup(from).length + able_to_insert_at_end
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
end
