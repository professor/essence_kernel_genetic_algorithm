class Individual

  attr_accessor :alphas

  def initialize()

  end

  def self.from_json_string(json_string)
    json = JSON.parse(json_string)

    individual = Individual.new
    individual.alphas = json['alphas']
    individual
  end

end
