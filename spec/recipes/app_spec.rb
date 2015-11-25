# Encoding: UTF-8

require 'spec_helper'

describe 'webhook::app' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the Webhook app' do
    expect(chef_run).to install_webhook_app('webhook')
  end
end
