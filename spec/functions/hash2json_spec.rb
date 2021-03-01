require 'spec_helper'

describe 'hash2json' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'hash2json' expects 1 argument, got none}) }
  it { is_expected.to run.with_params({}, {}).and_raise_error(ArgumentError, %r{'hash2json' expects 1 argument, got 2}) }
  it { is_expected.to run.with_params('some string').and_raise_error(ArgumentError, %r{'hash2json' parameter 'input' expects a Hash value, got String}) }

  example_input = {
    'domain' => 'example.com',
    'mysql'  => {
      'hosts' => ['192.0.2.2', '192.0.2.2'],
      'user'  => 'root',
      'pass'  => 'setec-astronomy',
    },
    'awesome' => true,
  }

  context 'default setting' do
    output = <<-EOS
{
  "domain": "example.com",
  "mysql": {
    "hosts": [
      "192.0.2.2",
      "192.0.2.2"
    ],
    "user": "root",
    "pass": "setec-astronomy"
  },
  "awesome": true
}
EOS

    it { is_expected.to run.with_params(example_input).and_return(output) }
  end
end
