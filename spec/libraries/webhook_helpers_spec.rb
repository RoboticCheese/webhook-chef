# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Spec:: libraries/webhook_helpers
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
require_relative '../../libraries/webhook_helpers'

describe Webhook::Helpers do
  let(:test_object) { Class.new { include Webhook::Helpers }.new }

  describe '#wh_app_name' do
    it 'returns the application name' do
      expect(test_object.wh_app_name).to eq('Webhook')
    end
  end

  describe '#wh_app_package_repo' do
    it 'returns the Webhook application package dir' do
      expected = 'http://dump.webhook.com/application'
      expect(test_object.wh_app_package_repo).to eq(expected)
    end
  end

  describe '#valid_version?' do
    let(:version) { nil }
    let(:res) { test_object.valid_version?(version) }

    context 'a valid version string' do
      let(:version) { '1.2.3' }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'an invalid version string' do
      let(:version) { '1.2.3.4' }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end
end
