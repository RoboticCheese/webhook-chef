# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Spec:: recipes/cli
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
