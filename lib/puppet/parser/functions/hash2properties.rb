module Puppet::Parser::Functions
  newfunction(:hash2properties, :type => :rvalue, :doc => <<-EOS
This converts a puppet hash to an properties string.
    EOS
  ) do |arguments|

    if arguments.size < 1
      raise(Puppet::ParseError, 'hash2properties(): requires at least one argument')
    end
    if arguments.size >= 3
      raise(Puppet::ParseError, 'hash2properties(): too many arguments')
    end
    unless arguments[0].is_a?(Hash)
      arg_class=arguments[0].class
      raise(Puppet::ParseError, "hash2properties(): requires a hash as argument (received #{arg_class})")
    end

    from_hash = arguments[0]

    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'key_val_separator' => '=',
      'quote_char'        => '',
      'list_separator'    => ',',
    }

    if arguments[1]
      unless arguments[1].is_a?(Hash)
        arg_class=arguments[1].class
        raise(Puppet::ParseError, "hash2properties(): Requires a hash as argument (received #{arg_class})")
      end
      settings.merge!(arguments[1])
    end

    properties_str=[]

    key_hashes = from_hash.to_a
    # puts "Key hashes: ", String(key_hashes)
    properties = {}
    list_separator=settings['list_separator']
    while key_hashes.size > 0
      key_value = key_hashes.pop
      if key_value[1].is_a?(Hash)
        key_hashes += key_value[1].to_a.map { |key,value| [ "#{key_value[0]}.#{key}", value ] }
      else
        if key_value[1].is_a?(Array)
          prop_value=key_value[1].join(list_separator)
        else
          prop_value=key_value[1]
        end
        properties[key_value[0]] = prop_value
      end
    end


    key_val_separator=settings['key_val_separator']
    quote_char=settings['quote_char']

    properties.each do | property, value |
      properties_str << "#{property}#{key_val_separator}#{quote_char}#{value}#{quote_char}"
    end

    properties_str.sort!{ |x,y| String(x) <=> String(y) }
    properties_str.insert(0, settings['header'], '')
    properties_str << ''

    return properties_str.join("\n")
  end
end
