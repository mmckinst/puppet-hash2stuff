# @summary Converts a puppet hash to INI file string.
Puppet::Functions.create_function(:hash2ini) do
  # @param input The hash to be converted to INI file
  # @param options A hash of options to control INI file format
  # @return [String] An INI file formatted string
  # @example Call the function with the $input and $options hashes
  #   hash2ini($input, $options)
  dispatch :ini do
    param 'Hash', :input
    optional_param 'Hash', :options
  end

  def ini(input, options = {})
    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'section_prefix'    => '[',
      'section_suffix'    => ']',
      'key_val_separator' => '=',
      'quote_char'        => '"',
      'quote_booleans'    => true,
      'quote_numerics'    => true,
    }

    settings.merge!(options)

    output = []
    output << settings['header'] << nil
    input.keys.each do |section|
      output << "#{settings['section_prefix']}#{section}#{settings['section_suffix']}"
      input[section].each do |k, v|
        v_is_a_boolean = (v.is_a?(TrueClass) || v.is_a?(FalseClass))
        output << if (v_is_a_boolean && !settings['quote_booleans']) || (v.is_a?(Numeric) && !settings['quote_numerics'])
                    "#{k}#{settings['key_val_separator']}#{v}"
                  else
                    "#{k}#{settings['key_val_separator']}#{settings['quote_char']}#{v}#{settings['quote_char']}"
                  end
      end
      output << nil
    end
    output.join("\n")
  end
end
