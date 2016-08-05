require 'spec_helper'

describe 'hash2yaml' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /requires one and only one argument/) }
  it { is_expected.to run.with_params({}, {}, {}).and_raise_error(Puppet::ParseError, /requires one and only one argument/) }
  it { is_expected.to run.with_params('some string').and_raise_error(Puppet::ParseError, /requires a hash as argument/) }

  example_input = {
    'domain' => 'example.com',
    'mysql'  => {
      'hosts' => ['192.0.2.2', '192.0.2.4'],
      'user'  => 'root',
      'pass'  => 'setec-astronomy',
    },
    'awesome'  => true,
  }


  context 'default setting' do
    # https://github.com/hallettj/zaml/issues/3
    # https://tickets.puppetlabs.com/browse/PUP-3120
    # https://tickets.puppetlabs.com/browse/PUP-5630
    #
    # puppet 3.x uses ZAML which formats YAML output differently than puppet 4.x

    if Puppet.version.to_f < 4.0
      output=<<-EOS
--- 
  domain: example.com
  mysql: 
    hosts: 
      - "192.0.2.2"
      - "192.0.2.4"
    user: root
    pass: setec-astronomy
  awesome: true
EOS
    else
      output=<<-EOS
---
domain: example.com
mysql:
  hosts:
  - 192.0.2.2
  - 192.0.2.4
  user: root
  pass: setec-astronomy
awesome: true
EOS
    end

    it { is_expected.to run.with_params(example_input).and_return(output) }

  end
end
