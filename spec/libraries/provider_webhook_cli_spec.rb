# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_webhook_cli'

describe Chef::Provider::WebhookCli do
  let(:name) { 'default' }
  let(:version) { 'latest' }
  let(:grunt_version) { nil }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    r = Chef::Resource::WebhookCli.new(name, run_context)
    r.version(version) unless version.nil?
    r.grunt_version(grunt_version) unless grunt_version.nil?
    r
  end
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#whyrun_supported?' do
    it 'advertises WhyRun support' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#load_current_resource' do
    it 'returns a Webhook CLI resource' do
      expected = Chef::Resource::WebhookCli
      expect(provider.load_current_resource).to be_an_instance_of(expected)
    end
  end

  describe '#action_install' do
    let(:grunt_package) { double(run_action: true) }
    let(:wh_package) { double(run_action: true) }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:grunt_package)
        .and_return(grunt_package)
      allow_any_instance_of(described_class).to receive(:wh_package)
        .and_return(wh_package)
      allow_any_instance_of(described_class).to receive(:new_resource)
        .and_return(new_resource)
    end

    it 'installs the Grunt package' do
      expect(grunt_package).to receive(:run_action).with(:install)
      provider.action_install
    end

    it 'installs the wh package' do
      expect(wh_package).to receive(:run_action).with(:install)
      provider.action_install
    end

    it 'sets the installed state to true' do
      expect(new_resource).to receive(:'installed=').with(true)
      provider.action_install
    end
  end

  describe '#action_uninstall' do
    let(:grunt_package) { double(run_action: true) }
    let(:wh_package) { double(run_action: true) }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:grunt_package)
        .and_return(grunt_package)
      allow_any_instance_of(described_class).to receive(:wh_package)
        .and_return(wh_package)
      allow_any_instance_of(described_class).to receive(:new_resource)
        .and_return(new_resource)
    end

    it 'uninstalls the wh package' do
      expect(wh_package).to receive(:run_action).with(:uninstall)
      provider.action_uninstall
    end

    it 'uninstalls the Grunt' do
      expect(grunt_package).to receive(:run_action).with(:uninstall)
      provider.action_uninstall
    end

    it 'sets the installed state to false' do
      expect(new_resource).to receive(:'installed=').with(false)
      provider.action_uninstall
    end
  end

  describe '#wh_package' do
    shared_examples_for 'any node' do
      it 'returns a NodejsNpm resource instance' do
        expected = Chef::Resource::NodejsNpm
        p = provider
        expect(p.send(:wh_package)).to be_an_instance_of(expected)
        expect(p.instance_variable_get(:@wh_package)).to be_an_instance_of(
          expected
        )
      end
    end

    context 'no version override' do
      it_behaves_like 'any node'

      it 'passes no version to the package resource' do
        expect_any_instance_of(Chef::Resource::NodejsNpm)
          .not_to receive(:version)
        provider.send(:wh_package)
      end
    end

    context 'a version override' do
      let(:version) { '3.2.1' }

      it_behaves_like 'any node'

      it 'passes the overridden version to the package resource' do
        expect_any_instance_of(Chef::Resource::NodejsNpm)
          .to receive(:version).with('3.2.1')
        provider.send(:wh_package)
      end
    end
  end

  describe '#grunt_package' do
    shared_examples_for 'any node' do
      it 'returns a NodejsNpm resource instance' do
        expected = Chef::Resource::NodejsNpm
        p = provider
        expect(p.send(:grunt_package)).to be_an_instance_of(expected)
        expect(p.instance_variable_get(:@grunt_package))
          .to be_an_instance_of(expected)
      end
    end

    context 'no version override' do
      it_behaves_like 'any node'

      it 'passes the default version to the package resource' do
        expect_any_instance_of(Chef::Resource::NodejsNpm)
          .to receive(:version).with('latest')
        provider.send(:grunt_package)
      end
    end

    context 'a version override' do
      let(:grunt_version) { '3.2.1' }

      it_behaves_like 'any node'

      it 'passes the overridden version to the package resource' do
        expect_any_instance_of(Chef::Resource::NodejsNpm)
          .to receive(:version).with('3.2.1')
        provider.send(:grunt_package)
      end
    end
  end
end
