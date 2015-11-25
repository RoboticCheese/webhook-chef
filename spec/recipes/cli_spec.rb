# Encoding: UTF-8

require 'spec_helper'

describe 'webhook::cli' do
  let(:attrs) { {} }
  let(:runner) do
    ChefSpec::Runner.new do |node|
      attrs.each { |k, v| node.set['webhook']['cli'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs Node.js' do
    expect(chef_run).to include_recipe('nodejs')
  end

  context 'all default attributes' do
    it 'installs the Webhook CLI' do
      expect(chef_run).to install_webhook_cli('webhook')
    end
  end

  context 'an overridden version attribute' do
    let(:attrs) { { version: '1.2.3' } }

    it 'installs the desired version of the Webhook CLI' do
      expect(chef_run).to install_webhook_cli('webhook').with(version: '1.2.3')
    end
  end

  context 'an overridden Grunt version attribute' do
    let(:attrs) { { grunt_version: '3.2.1' } }

    it 'installs the desired version of Grunt' do
      expect(chef_run).to install_webhook_cli('webhook')
        .with(grunt_version: '3.2.1')
    end
  end
end
