# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_webhook_cli'

describe Chef::Resource::WebhookCli do
  let(:name) { 'default' }
  let(:version) { nil }
  let(:grunt_version) { nil }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }

  let(:resource) do
    r = described_class.new(name, run_context)
    r.version(version) unless version.nil?
    r.grunt_version(grunt_version) unless grunt_version.nil?
    r
  end

  describe '#initialize' do
    it 'defaults to the install action' do
      expect(resource.instance_variable_get(:@action)).to eq(:install)
      expect(resource.action).to eq(:install)
    end

    it 'defaults the state to uninstalled' do
      expect(resource.instance_variable_get(:@installed)).to eq(false)
      expect(resource.installed?).to eq(false)
    end
  end

  describe '#version' do
    context 'no override provided' do
      it 'defaults to the latest version' do
        expect(resource.version).to eq('latest')
      end
    end

    context 'a valid override provided' do
      let(:version) { '1.2.3' }

      it 'returns the overridden value' do
        expect(resource.version).to eq(version)
      end
    end

    context 'an invalid override provided' do
      let(:version) { '1.2.z' }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#grunt_version' do
    context 'no override provided' do
      it 'defaults to the latest version' do
        expect(resource.grunt_version).to eq('latest')
      end
    end

    context 'a valid override provided' do
      let(:grunt_version) { '1.2.3' }

      it 'returns the overridden value' do
        expect(resource.grunt_version).to eq(grunt_version)
      end
    end

    context 'an invalid override provided' do
      let(:grunt_version) { '1.2.z' }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
