require_relative '../lib/essence_kernel_genetic_algorithm/individual.rb'
require 'JSON'

describe Individual do
  
  it 'can load CMU1.1 kernel from disk' do
    json_string = File.read(File.expand_path('../fixtures/CMU_1.1.json', __FILE__))
    individual = Individual.from_json_string(json_string)
    alphas = individual.alphas

    expect(alphas.length).to eq 7
    expect(alphas[0]['states'].length).to eq 7
    expect(alphas[1]['states'].length).to eq 6
    expect(alphas[2]['states'].length).to eq 6
    expect(alphas[3]['states'].length).to eq 7
    expect(alphas[4]['states'].length).to eq 5
    expect(alphas[5]['states'].length).to eq 4
    expect(alphas[6]['states'].length).to eq 6
  end


  it 'copies name and color to checklists' do

  end




end
