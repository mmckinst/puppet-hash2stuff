require 'spec_helper'

describe 'hash2kv' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'hash2kv' expects between 1 and 2 arguments, got none}) }
  it { is_expected.to run.with_params({}, {}, {}).and_raise_error(ArgumentError, %r{'hash2kv' expects between 1 and 2 arguments, got 3}) }
  it { is_expected.to run.with_params('some string').and_raise_error(ArgumentError, %r{'hash2kv' parameter 'input' expects a Hash value, got String}) }

  example_input = {
    'HOSTNAME'     => 'foo.example.com',
    'RSYNC_IONICE' => '3',
    'PORTS'        => '53 123 80',
  }

  context 'no custom settings' do
    output = <<-EOS
# THIS FILE IS CONTROLLED BY PUPPET

HOSTNAME="foo.example.com"
RSYNC_IONICE="3"
PORTS="53 123 80"
EOS

    it { is_expected.to run.with_params(example_input).and_return(output) }
  end

  context 'custom settings' do
    settings = {
      'header'            => '; THIS FILE IS CONTROLLED BY /dev/random',
      'key_val_separator' => ': ',
      'quote_char'        => '',
    }
    output = <<-EOS
; THIS FILE IS CONTROLLED BY /dev/random

HOSTNAME: foo.example.com
RSYNC_IONICE: 3
PORTS: 53 123 80
EOS
    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end
end
