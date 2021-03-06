# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::userdir', type: :class do
  context 'on a Debian OS' do
    let :pre_condition do
      'class { "apache":
         default_mods => false,
         mod_dir      => "/tmp/junk",
       }'
    end

    include_examples 'Debian 8'

    context 'default parameters' do
      it { is_expected.to compile }
    end
    context 'with dir set to something' do
      let :params do
        {
          dir: 'hi',
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+/home/\*/hi$}) }
      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*\<Directory\s+\"/home/\*/hi\"\>$}) }
    end
    context 'with home set to something' do
      let :params do
        {
          home: '/u',
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+/u/\*/public_html$}) }
      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*\<Directory\s+\"/u/\*/public_html"\>$}) }
    end
    context 'with path set to something' do
      let :params do
        {
          path: 'public_html /usr/web http://www.example.com/',
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+public_html /usr/web http://www\.example\.com/$}) }
      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*\<Directory\s+\"public_html /usr/web http://www\.example\.com/\"\>$}) }
    end
    context 'with unmanaged_path set to true' do
      let :params do
        {
          unmanaged_path: true,
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+/home/\*/public_html$}) }
      it { is_expected.not_to contain_file('userdir.conf').with_content(%r{^\s*\<Directory }) }
    end
    context 'with custom_fragment set to something' do
      let :params do
        {
          custom_fragment: 'custom_test_string',
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{custom_test_string}) }
    end
  end
end
