require 'spec_helper'

describe 'hash2yaml' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /requires one and only one argument/) }
  it { is_expected.to run.with_params({}, {}, {}).and_raise_error(Puppet::ParseError, /requires one and only one argument/) }
  it { is_expected.to run.with_params('some string').and_raise_error(Puppet::ParseError, /requires a hash as argument/) }

  example_input = {
    'domain' => 'example.com',
    'mysql'  => {
      'hosts' => ['192.0.2.2', '192.0.2.2'],
      'user'  => 'root',
      'pass'  => 'setec-astronomy',
    },
    'awesome'  => true,
  }

  context 'default setting' do
    output=<<-EOS
---
domain: example.com
mysql:
  hosts:
  - 192.0.2.2
  - 192.0.2.2
  user: root
  pass: setec-astronomy
awesome: true
EOS

    it { is_expected.to run.with_params(example_input).and_return(output) }
  end
end
