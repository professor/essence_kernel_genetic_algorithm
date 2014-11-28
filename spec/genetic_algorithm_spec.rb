require_relative '../lib/essence_kernel_genetic_algorithm/genetic_algorithm.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/completion.rb'

describe GeneticAlgorithm do

  it 'works' do
    Random.srand(1234)

    subject.run(Completion, {runs: 1, generations: 11, number_of_alphas: 42})
    subject.run(PartialOrdering, {runs: 1, generations: 11, number_of_alphas: 42})

  end

end




