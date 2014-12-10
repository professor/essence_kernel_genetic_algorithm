# EssenceKernelGeneticAlgorithm

The SEMAT community released the Essence Kernel in 2012.
This software is a genetic algorithm that use empirical data to derive alternative kernels.

If you are looking for a tool to help you with Essence, check out (SEMAT Essence Tool)[http://semat.herokuapp.com]

## Directions for installation

1) determine which version of ruby is on your system

    ruby --version

Note: I’m using ruby 2.1.1, but anything 1.9 or larger should probably work

2) Update the Gemfile with the version of ruby that you are using

    vi Gemfile

3) install bundler, the ruby library manager

    gem install bundler

4) install ruby libraries

    bundle install

5) run the test suite

    rspec spec/*

6) run the code

    modify spec/genetic_algorithm_spec.rb and lib/essence_kernel_genetic_algorithm/genetic_algorithm.rb for run parameters
    rspec spec/genetic_algorithm_spec.rb

    for incremental updates to the Essence Kernel run:
    rspec spec/simple_algorithm_spec.rb




## Contributing

1. Fork it ( https://github.com/[my-github-username]/essence_kernel_genetic_algorithm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
