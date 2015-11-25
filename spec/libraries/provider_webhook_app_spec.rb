# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_webhook_app'

describe Chef::Provider::WebhookApp do
  let(:name) { 'default' }
  let(:platform) { {} }
  let(:package_url) { nil }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    r = Chef::Resource::WebhookApp.new(name, run_context)
    r.package_url(package_url) unless package_url.nil?
    r
  end
  let(:provider) { described_class.new(new_resource, run_context) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:node)
      .and_return(Fauxhai.mock(platform).data)
  end

  describe '#whyrun_supported?' do
    it 'advertises WhyRun support' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#load_current_resource' do
    it 'returns a Webhook App resource' do
      expected = Chef::Resource::WebhookApp
      expect(provider.load_current_resource).to be_an_instance_of(expected)
    end
  end

  describe '#action_install' do
    let(:package) { double(run_action: true) }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:package)
        .and_return(package)
    end

    it 'installs the package' do
      expect(package).to receive(:run_action).with(:install)
      provider.action_install
    end

    it 'sets the installed state to true' do
      expect(new_resource).to receive(:'installed=').with(true)
      provider.action_install
    end
  end

  describe '#package' do
    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }

      it 'calls the OS X package resource method' do
        p = provider
        expect(p).to receive(:package_mac_os_x).and_return(true)
        expect(p).to_not receive(:package_windows)
        p.send(:package)
      end
    end

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012' } }

      it 'calls the Windows package resource method' do
        p = provider
        expect(p).to receive(:package_windows).and_return(true)
        expect(p).to_not receive(:package_mac_os_x)
        p.send(:package)
      end
    end

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '12.04' } }

      it 'raises an exception' do
        expect { provider.send(:package) }.to raise_error
      end
    end
  end

  describe '#package_mac_os_x' do
    let(:package_mac_os_x) { provider.send(:package_mac_os_x) }
    let(:filename) { 'Webhook.dmg' }
    let(:package_url) { 'http://example.com/Webhook.dmg' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:filename)
        .and_return(filename)
      allow_any_instance_of(described_class).to receive(:package_url)
        .and_return(package_url)
    end

    it 'returns a DmgPackage instance' do
      expected = Chef::Resource::DmgPackage
      expect(package_mac_os_x).to be_an_instance_of(expected)
    end

    it 'calls `app` correctly' do
      expect(package_mac_os_x.app).to eq('Webhook')
    end

    it 'calls `volumes_dir` correctly' do
      expect(package_mac_os_x.volumes_dir).to eq('Webhook')
    end

    it 'calls `source` correctly' do
      expect(package_mac_os_x.source).to eq(package_url)
    end

    it 'calls `type` correctly' do
      expect(package_mac_os_x.type).to eq('app')
    end
  end

  describe '#package_windows' do
    let(:package_windows) { provider.send(:package_windows) }
    let(:package_url) { 'http://example.com/setup.exe' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:package_url)
        .and_return(package_url)
    end

    it 'returns a WindowsPackage instance' do
      expected = Chef::Resource::WindowsPackage
      expect(package_windows).to be_an_instance_of(expected)
    end

    it 'sets `package_name` correctly' do
      expect(package_windows.package_name).to eq('Webhook')
    end

    it 'calls `source` correctly' do
      expect(package_windows.source).to eq(package_url)
    end
  end

  describe '#package_url' do
    context 'no URL override provided' do
      before(:each) do
        allow_any_instance_of(described_class).to receive(:filename)
          .and_return('file.dmg')
      end

      it 'constructs a URL for the system' do
        expected = 'http://dump.webhook.com/application/file.dmg'
        expect(provider.send(:package_url)).to eq(expected)
      end
    end

    context 'a URL override provided' do
      let(:package_url) { 'http://somewhere.else/file.dmg' }

      it 'returns that override' do
        expect(provider.send(:package_url)).to eq(package_url)
      end
    end
  end

  describe '#filename' do
    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }

      it 'returns the .dmg package' do
        expect(provider.send(:filename)).to eq('Webhook.dmg')
      end
    end

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012' } }

      it 'returns the .exe package' do
        expect(provider.send(:filename)).to eq('setup.exe')
      end
    end

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '12.04' } }

      it 'raises an exception' do
        expected = Chef::Exceptions::UnsupportedPlatform
        expect { provider.send(:filename) }.to raise_error(expected)
      end
    end
  end
end
