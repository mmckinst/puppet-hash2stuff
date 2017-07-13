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
    # https://github.com/hallettj/zaml/issues/3
    # https://tickets.puppetlabs.com/browse/PUP-3120
    # https://tickets.puppetlabs.com/browse/PUP-5630
    #
    # puppet 3.x uses ZAML which formats YAML output differently than puppet 4.x
    # including not ending the file with a new line
    if Puppet.version.to_f < 4.0
      return h.to_yaml.gsub(/^\s{2}/, '') << "\n"
    else
      return h.to_yaml
    end
  end
end
