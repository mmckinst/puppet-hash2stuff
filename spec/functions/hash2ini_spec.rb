require 'spec_helper'

describe 'hash2ini' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'hash2ini' expects between 1 and 2 arguments, got none}) }
  it { is_expected.to run.with_params({}, {}, {}).and_raise_error(ArgumentError, %r{'hash2ini' expects between 1 and 2 arguments, got 3}) }
  it { is_expected.to run.with_params('some string').and_raise_error(ArgumentError, %r{'hash2ini' parameter 'input' expects a Hash value, got String}) }

  example_input = {
    'main' => {
      'logging' => 'INFO',
      'limit'   => 314,
      'awesome' => true,
    },
    'dev' => {
      'logging'      => 'DEBUG',
      'log_location' => '/var/log/dev.log',
    },
  }

  context 'default settings' do
    output = <<-EOS
# THIS FILE IS CONTROLLED BY PUPPET

[main]
logging="INFO"
limit="314"
awesome="true"

[dev]
logging="DEBUG"
log_location="/var/log/dev.log"
EOS
    it { is_expected.to run.with_params(example_input).and_return(output) }
  end

  context 'custom settings' do
    settings = {
      'header'            => '; THIS FILE IS CONTROLLED BY /dev/random',
      'section_prefix'    => '[[',
      'section_suffix'    => ']]',
      'key_val_separator' => ': ',
      'quote_char'        => '',
    }
    output = <<-EOS
; THIS FILE IS CONTROLLED BY /dev/random

[[main]]
logging: INFO
limit: 314
awesome: true

[[dev]]
logging: DEBUG
log_location: /var/log/dev.log
EOS
    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end

  context 'default settings with custom quoting' do
    settings = {
      'quote_booleans' => false,
      'quote_numerics' => false,
    }
    output = <<-EOS
# THIS FILE IS CONTROLLED BY PUPPET

[main]
logging="INFO"
limit=314
awesome=true

[dev]
logging="DEBUG"
log_location="/var/log/dev.log"
EOS

    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end
end
