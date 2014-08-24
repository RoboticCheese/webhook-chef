# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Spec:: libraries/provider_webhook_cli
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
require_relative '../../libraries/provider_webhook_cli'

describe Chef::Provider::Webhook::CLI do
  let(:version) { 'latest' }
  let(:grunt_version) { nil }
  let(:new_resource) do
    double(name: 'webhook_cli',
           version: version,
           grunt_version: grunt_version)
  end
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#whyrun_supported?' do
    it 'advertises WhyRun support' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#load_current_resource' do
    it 'returns a Webhook CLI resource' do
      expected = Chef::Resource::Webhook::CLI
      expect(provider.load_current_resource).to be_an_instance_of(expected)
    end
  end

  describe '#action_install' do
    let(:grunt_package) { double(run_action: true) }
    let(:wh_package) { double(run_action: true) }
    let(:new_resource) { double(:'installed=' => true) }

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
    let(:new_resource) { double(:'installed=' => true) }

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

      it 'passes no version to the package resource' do
        expect_any_instance_of(Chef::Resource::NodejsNpm)
          .not_to receive(:version)
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
