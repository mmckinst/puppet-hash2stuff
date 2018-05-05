require 'spec_helper'

describe 'hash2properties' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /requires at least one argument/) }
  it { is_expected.to run.with_params({}, {}, {}).and_raise_error(Puppet::ParseError, /too many arguments/) }
  it { is_expected.to run.with_params('some string').and_raise_error(Puppet::ParseError, /requires a hash as argument/) }

  example_input = {
    'main' => {
      'logging' => 'INFO',
      'limit'   => 314,
      'awesome' => true,
      'nested'  => {
        'sublevel1' => 'value1',
        'subnested1' => {
          'node1' => 'leaf1',
          'node2' => 'leaf2',
        },
        'list' => [
          'item1',
          'item2',
        ]
      }
    },
    'dev' => {
      'logging'      => 'DEBUG',
      'log_location' => '/var/log/dev.log',
    }
  }

  context 'no custom settings' do
    output=<<-EOS
# THIS FILE IS CONTROLLED BY PUPPET

dev.log_location=/var/log/dev.log
dev.logging=DEBUG
main.awesome=true
main.limit=314
main.logging=INFO
main.nested.list=item1,item2
main.nested.sublevel1=value1
main.nested.subnested1.node1=leaf1
main.nested.subnested1.node2=leaf2
EOS
    it { is_expected.to run.with_params(example_input).and_return(output) }
  end

  context 'custom settings' do
    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY /dev/random',
      'key_val_separator' => ': ',
      'quote_char'        => '"',
    }
    output=<<-EOS
# THIS FILE IS CONTROLLED BY /dev/random

dev.log_location: "/var/log/dev.log"
dev.logging: "DEBUG"
main.awesome: "true"
main.limit: "314"
main.logging: "INFO"
main.nested.list: "item1,item2"
main.nested.sublevel1: "value1"
main.nested.subnested1.node1: "leaf1"
main.nested.subnested1.node2: "leaf2"
EOS
    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end
end
