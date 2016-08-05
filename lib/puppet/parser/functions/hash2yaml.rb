module Puppet::Parser::Functions
  newfunction(:hash2yaml, :type => :rvalue, :doc => <<-EOS
This converts a puppet hash to YAML string.
    EOS
  ) do |arguments|
    require 'yaml'

    if arguments.size != 1
      raise(Puppet::ParseError, 'hash2yaml(): requires one and only one argument')
    end
    unless arguments[0].is_a?(Hash)
      raise(Puppet::ParseError, 'hash2yaml(): requires a hash as argument')
    end

    h = arguments[0]

    return h.to_yaml
  end
end
