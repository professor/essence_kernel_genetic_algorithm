require_relative './individual.rb'
require_relative './operators.rb'
require_relative './empirical_data.rb'
require_relative './team_data_collection.rb'

class GeneticAlgorithm

  def initial_kernel_population(population_size)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)

    population = []
    population_size.times do
      candidate = original.deep_clone
      population << candidate
    end
    population
  end

  def initial_population(population_size)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)

    population = []
    population_size.times do
      copy = original.deep_clone
      empty = Individual.create(6, 6)
      empty.populate_from(copy)
      population << empty
    end
    population
  end


  def apply_operators(population)
    total_number_of_checklists = population[0].total_number_of_checklists

    population.length.times do |index|
      parent = population[index]
      candidate = parent.deep_clone
      if (Random.rand > 0.1)
        Operators.move_random_checklist_anywhere(candidate)
      else
        Operators.delete_random_state(candidate)
      end

      number_of_checklists = candidate.total_number_of_checklists
      if(number_of_checklists != total_number_of_checklists)
        puts 'we have a problem!'
        binding.pry
      end

      population << candidate
    end
    population
  end

  def calculate_fitness(population, fitness_class)
    population.each do |member|
      score_hash = fitness_class.evaluate(member, @team_data)
      member.fitness = score_hash[:total]
    end
  end

  def best_mean_worst_fitness(population)
    population_size = population.length
    best_fitness = population[0].fitness
    worst_fitness = population[population_size - 1].fitness

    mean_total = 0
    for ind in population
      mean_total += ind.fitness
    end
    mean_fitenss = mean_total / population_size
    return best_fitness, mean_fitenss, worst_fitness
  end


  def run(fitness_class)
    population_size = 20
    maximum_runs = 1
    maximum_generations = 20
    run = 0
    @team_data = EmpiricalData.load_team_data

    while run < maximum_runs
      population = initial_population(population_size)

      generation = 0
      while generation < maximum_generations
        population = apply_operators(population)
        population = calculate_fitness(population, fitness_class)
        population = population.sort_by { |member| member.fitness }.reverse
        population = population.slice(0..population_size - 1)

        best_individual = population[0]

        (best_fitness, mean_fitness, worst_fitness) = best_mean_worst_fitness(population)

        File.write(File.expand_path("../../../generated_kernels/genetic_#{fitness_class.to_s.downcase}_#{run}_#{generation}.json", __FILE__), JSON.pretty_generate(best_individual.alphas))

        puts "run= #{run}, generation= #{generation}, best_fitness = #{best_fitness}, average_fitness = #{mean_fitness}, worst_fitness = #{worst_fitness}"
        generation += 1
      end

      population[0].pretty_print
      run += 1
    end
  end
end
