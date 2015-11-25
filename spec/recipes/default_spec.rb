# Encoding: UTF-8

require 'spec_helper'

describe 'webhook::default' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it "doesn't do anything yet" do
    expect(true).to eq(true)
  end
end
