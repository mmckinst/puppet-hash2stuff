module Puppet::Parser::Functions
  newfunction(:hash2kv, :type => :rvalue, :doc => <<-EOS
This converts a puppet hash to an key-value string.
    EOS
  ) do |arguments|

    if arguments.size < 1
      raise(Puppet::ParseError, 'hash2kv(): requires at least one argument')
    end
    if arguments.size >= 3
      raise(Puppet::ParseError, 'hash2kv(): too many arguments')
    end
    unless arguments[0].is_a?(Hash)
      raise(Puppet::ParseError, 'hash2kv(): requires a hash as argument')
    end

    h = arguments[0]

    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'key_val_separator' => '=',
      'quote_char'        => '"',
    }

    if arguments[1]
      unless arguments[1].is_a?(Hash)
        raise(Puppet::ParseError, 'hash2kv(): Requires a hash as argument')
      end
      settings.merge!(arguments[1])
    end



    kv = []
    kv << settings['header'] << nil
    h.each do |k,v|
      kv << "#{k}#{settings['key_val_separator']}#{settings['quote_char']}#{v}#{settings['quote_char']}"
    end
    kv << nil
    return kv.join("\n")
  end
end
