module Puppet::Parser::Functions
  newfunction(:hash2yaml, type: :rvalue, doc: <<-EOS
This converts a puppet hash to YAML string.
    EOS
             ) do |arguments|
    require 'yaml'

    if arguments.empty?
      raise(Puppet::ParseError, 'hash2yaml(): requires at least one argument')
    end
    if arguments.size >= 3
      raise(Puppet::ParseError, 'hash2yaml(): too many arguments')
    end
    unless arguments[0].is_a?(Hash)
      raise(Puppet::ParseError, 'hash2yaml(): requires a hash as argument')
    end

    h = arguments[0]

    settings = {
      'header' => '',
    }

    if arguments[1]
      unless arguments[1].is_a?(Hash)
        raise(Puppet::ParseError, 'hash2yaml(): Requires a hash as second argument')
      end
      settings.merge!(arguments[1])
    end

    # https://github.com/hallettj/zaml/issues/3
    # https://tickets.puppetlabs.com/browse/PUP-3120
    # https://tickets.puppetlabs.com/browse/PUP-5630
    #
    # puppet 3.x uses ZAML which formats YAML output differently than puppet 4.x
    # including not ending the file with a new line
    output = if Puppet.version.to_f < 4.0
               h.to_yaml << "\n"
             else
               h.to_yaml
             end

    if settings['header'].to_s.empty?
      return output
    else
      return "#{settings['header']}\n#{output}"
    end
  end
end
