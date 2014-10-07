# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Spec:: libraries/provider_webhook_app
#
# Copyright (C) 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../spec_helper'
require_relative '../../libraries/provider_webhook_app'

describe Chef::Provider::WebhookApp do
  let(:platform) { {} }
  let(:package_url) { nil }
  let(:new_resource) do
    double(name: 'webhook', package_url: package_url, :'installed=' => true)
  end
  let(:provider) { described_class.new(new_resource, nil) }

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
        p.send(:package)
      end
    end

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012' } }

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

  describe '#package_url' do
    context 'no URL override provided' do
      before(:each) do
        allow_any_instance_of(described_class).to receive(:filename)
          .and_return('file.file')
      end

      it 'constructs a URL for the system' do
        expected = 'http://dump.webhook.com/application/file.file'
        expect(provider.send(:package_url)).to eq(expected)
      end
    end

    context 'a URL override provided' do
      let(:package_url) { 'http://somewhere.else/file.file' }

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

      it 'raises an exception' do
        expected = Chef::Exceptions::UnsupportedPlatform
        expect { provider.send(:filename) }.to raise_error(expected)
      end
    end
  end
end
