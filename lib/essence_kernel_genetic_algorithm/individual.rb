class Individual

  attr_accessor :alphas

  def initialize()

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

  def index_parts(hash)
    return [hash[:alpha], hash[:state], hash[:checklist]]
  end
end
