require_relative './individual.rb'
require_relative './operators.rb'
require_relative './empirical_data.rb'
require_relative './team_data_collection.rb'

class GeneticAlgorithm

  def initial_kernel_population(population_size, fitness_class)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)
    original.apply_team_data_meeting_numbers(@team_data)

    population = []
    population_size.times do
      candidate = original.deep_clone
      candidate.calculate_fitness(fitness_class, @team_data)
      population << candidate
    end
    population
  end

  def initial_population(population_size, number_of_alphas, fitness_class)
    kernel_json_string = File.read(File.expand_path('../../../spec/fixtures/CMU_1.1.json', __FILE__))
    original = Individual.from_json_string(kernel_json_string)
    original.apply_team_data_meeting_numbers(@team_data)

    population = []
    population_size.times do
      copy = original.deep_clone
      empty = Individual.create({number_of_alphas: number_of_alphas,
        number_of_states: Random.rand(1..12)})
      # empty = Individual.create({number_of_alphas: number_of_alphas,
      #   number_of_states: 6})
      empty.populate_from(copy)
      empty.calculate_fitness(fitness_class, @team_data)
      population << empty
    end
    population
  end

  def apply_operators(population, fitness_class)
    total_number_of_checklists = population[0].total_number_of_checklists

    population.length.times do |index|
      parent = population[index]
      candidate = parent.deep_clone
      random = Random.rand
      operator = nil
      if (random > 0.2)
        Operators.move_random_checklist_anywhere(candidate)
        operator = 'Move checklist'
        operator += ' and split state' if parent.total_number_of_states != candidate.total_number_of_states
      elsif (random > 0.1)
        Operators.split_random_state(candidate)
        operator = 'Split state'
      else
        Operators.delete_random_state(candidate)
        operator = 'Delete state'
      end

      number_of_checklists = candidate.total_number_of_checklists
      if(number_of_checklists != total_number_of_checklists)
        puts 'we have a problem!'
        binding.pry
      end

      candidate.calculate_fitness(fitness_class, @team_data)
      # puts "#{operator}, #{parent.fitness}, #{candidate.fitness}, #{candidate.fitness - parent.fitness}"
      population << candidate
    end
    population
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

  def most_mean_least_number_of_states(population)
    population_size = population.length
    most = population[0].total_number_of_states
    least = most

    total_number_states = 0
    population.each do |individual|
      number_of_states = individual.total_number_of_states
      total_number_states += number_of_states
      most = number_of_states if number_of_states > most
      least = number_of_states if number_of_states < least
    end
    mean = total_number_states / population_size
    return most, mean, least
  end

  def fitness_not_signficantly_improving(best_fitness, last_best_fitness)
    # (best_fitness - last_best_fitness) / last_best_fitness.to_f < 0.0001
    best_fitness == last_best_fitness
  end

  def run(fitness_class, options)
    population_size = 40
    maximum_runs = options[:runs] || 1
    maximum_generations = options[:generations] || 20
    number_of_alphas = options[:number_of_alphas] || 7

    run = 0
    @team_data = EmpiricalData.load_team_data

    alpha_directory = "three_operators_#{number_of_alphas}_by_random"
    fitness_directory = "genetic_#{fitness_class.to_s.downcase}"
    directory = alpha_directory + '/' + fitness_directory
    system 'mkdir', '-p', "generated_kernels/#{alpha_directory}"
    system 'mkdir', '-p', "generated_kernels/#{directory}"

    File.open(File.expand_path("../../../generated_kernels/#{directory}/pretty_print.txt", __FILE__), 'w')
    log = File.open(File.expand_path("../../../generated_kernels/#{directory}/log.csv", __FILE__), 'w')

    puts "tail -f generated_kernels/#{directory}/log.csv"
    puts "tail -f generated_kernels/#{directory}/pretty_print.txt"

    log.puts "run, generation, best_fitness, average_fitness, worst_fitness"

    fitness_results = {best: [], average: [], worst: []}
    number_of_states_results = {best: [], average: [], worst: []}

    while run < maximum_runs
      population = initial_population(population_size, number_of_alphas, fitness_class)

      generation = 0
      best_fitness_10_generations_ago = 0
      best_fitness_20_generations_ago = 0
      while generation <= maximum_generations
        population = apply_operators(population, fitness_class)
        population = population.sort_by { |member| member.fitness }.reverse
        population = population.slice(0..population_size - 1)

        best_individual = population[0]

        (best_fitness, mean_fitness, worst_fitness) = best_mean_worst_fitness(population)

        if(generation % 10 == 0)
          File.write(File.expand_path("../../../generated_kernels/#{directory}/#{run}_#{generation}.json", __FILE__), JSON.pretty_generate(best_individual.alphas))
          File.open(File.expand_path("../../../generated_kernels/#{directory}/pretty_print.txt", __FILE__), 'a') do |f|
            best_individual.pretty_print_to_file(f)
          end
          # break if generation > 100 and fitness_not_signficantly_improving(best_fitness, best_fitness_20_generations_ago)
          best_fitness_20_generations_ago = best_fitness_10_generations_ago
          best_fitness_10_generations_ago = best_fitness

        end
        update_run_results(fitness_results, run, generation, best_fitness, mean_fitness, worst_fitness)

        (most_number_of_states, mean_number_of_states, least_number_of_states) = most_mean_least_number_of_states(population)
        update_run_results(number_of_states_results, run, generation, most_number_of_states, mean_number_of_states, least_number_of_states)

        log.puts "#{run}, #{generation}, #{best_fitness}, #{mean_fitness}, #{worst_fitness}"
        log.flush
        generation += 1
      end

      population[0].pretty_print
      run += 1
    end

    print_run_results(log, "Fitness", fitness_results, maximum_runs, maximum_generations)
    print_run_results(log, "Number of states", number_of_states_results, maximum_runs, maximum_generations)

    log.close
  end

  def update_run_results(run_results, run, generation, best_fitness, mean_fitness, worst_fitness)
    generation_index = generation
    if run == 0
      run_results[:best][generation_index] = best_fitness
      run_results[:average][generation_index] = mean_fitness
      run_results[:worst][generation_index] = worst_fitness
    else
      run_results[:best][generation_index] = best_fitness if best_fitness > run_results[:best][generation_index]
      run_results[:average][generation_index] += mean_fitness
      run_results[:worst][generation_index] = worst_fitness if worst_fitness < run_results[:worst][generation_index]
    end
  end

  def print_run_results(log, header, run_results, runs, length)
    log.puts header
    puts header
    log.puts 'Generation, Best, Average, Worst'
    puts 'Generation, Best, Average, Worst'
    length.times.each do |index|
      log.puts "#{index }, #{run_results[:best][index]}, #{run_results[:average][index] / runs}, #{run_results[:worst][index]}"
      puts "#{index }, #{run_results[:best][index]}, #{run_results[:average][index] / runs}, #{run_results[:worst][index]}"
    end
  end
end
