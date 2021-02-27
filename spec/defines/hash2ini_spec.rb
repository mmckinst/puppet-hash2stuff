# frozen_string_literal: true

require 'spec_helper'

describe 'hash2stuff::hash2ini' do
  let(:params) do
    {
      file_props: {
        ensure: 'file',
      },
      data_hash: {
        section1: {
          key1: 'value1',
        },
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os =~ %r{windows}i
        let(:title) { 'C:\\Temp\\spec_ini.tmp' }
      else
        let(:title) { '/tmp/spec_ini.tmp' }
      end
      it { is_expected.to compile }
    end
  end
end
