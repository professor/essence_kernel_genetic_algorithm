require_relative '../lib/essence_kernel_genetic_algorithm/genetic_algorithm.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/partial_ordering.rb'
require_relative '../lib/essence_kernel_genetic_algorithm/fitness_functions/completion.rb'

describe GeneticAlgorithm do

  it 'for automated testing, we set the parameters low' do
    Random.srand(1234)

    subject.run(Completion, {runs: 1, generations: 11, number_of_alphas: 42})
    subject.run(PartialOrdering, {runs: 1, generations: 11, number_of_alphas: 42})

  end

  it 'for a real run use these' do
    Random.srand(1234)

    # subject.run(Completion, {runs: 40, generations: 120, number_of_alphas: 8})
    # subject.run(PartialOrdering, {runs: 40, generations: 120, number_of_alphas: 4})
  end

end




