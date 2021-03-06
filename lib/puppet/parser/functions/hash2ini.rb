module Puppet::Parser::Functions
  newfunction(:hash2ini, :type => :rvalue, :doc => <<-EOS
This converts a puppet hash to an INI string.
    EOS
  ) do |arguments|

    if arguments.size < 1
      raise(Puppet::ParseError, 'hash2ini(): requires at least one argument')
    end
    if arguments.size >= 3
      raise(Puppet::ParseError, 'hash2ini(): too many arguments')
    end
    unless arguments[0].is_a?(Hash)
      raise(Puppet::ParseError, 'hash2ini(): requires a hash as argument')
    end

    h = arguments[0]

    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'section_prefix'    => '[',
      'section_suffix'    => ']',
      'key_val_separator' => '=',
      'quote_char'        => '"',
      "quote_booleans"    => true,
      "quote_numerics"    => true,
    }

    if arguments[1]
      unless arguments[1].is_a?(Hash)
        raise(Puppet::ParseError, 'hash2ini(): Requires a hash as argument')
      end
      settings.merge!(arguments[1])
    end



    ini = []
    ini << settings['header'] << nil
    h.keys.each do |section|
      ini << "#{settings['section_prefix']}#{section}#{settings['section_suffix']}"
      h[section].each do |k, v|
        v_is_a_boolean = (v.is_a?(TrueClass) or v.is_a?(FalseClass))

        if (v_is_a_boolean and not settings['quote_booleans']) or (v.is_a?(Numeric) and not settings['quote_numerics'])
          ini << "#{k}#{settings['key_val_separator']}#{v}"
        else
          ini << "#{k}#{settings['key_val_separator']}#{settings['quote_char']}#{v}#{settings['quote_char']}"
        end
      end
      ini << nil
    end
    return ini.join("\n")
  end
end
