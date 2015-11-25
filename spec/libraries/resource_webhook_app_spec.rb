# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_webhook_app'

describe Chef::Resource::WebhookApp do
  let(:name) { 'default' }
  let(:package_url) { nil }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }

  let(:resource) do
    r = described_class.new(name, run_context)
    r.package_url(package_url) unless package_url.nil?
    r
  end

  describe '#initialize' do
    it 'defaults to the proper provider' do
      expected = Chef::Provider::WebhookApp
      expect(resource.instance_variable_get(:@provider)).to eq(expected)
      expect(resource.provider).to eq(expected)
    end

    it 'defaults to the install action' do
      expect(resource.instance_variable_get(:@action)).to eq(:install)
      expect(resource.action).to eq(:install)
    end

    it 'defaults the state to uninstalled' do
      expect(resource.instance_variable_get(:@installed)).to eq(false)
      expect(resource.installed?).to eq(false)
    end
  end

  describe '#package_url' do
    context 'no override provided' do
      it 'defaults to nil (let the provider decide)' do
        expect(resource.package_url).to eq(nil)
      end
    end

    context 'a valid override provided' do
      let(:package_url) { 'https://example.com/pkg.dmg' }

      it 'returns the overridden value' do
        expect(resource.package_url).to eq(package_url)
      end
    end

    context 'an invalid override provided' do
      let(:package_url) { 'https://example.com/pkg.pack' }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
