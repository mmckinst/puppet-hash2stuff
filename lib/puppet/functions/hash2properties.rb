# @summary Converts a puppet hash to Java properties file string.
Puppet::Functions.create_function(:hash2properties) do
  # @param input The hash to be converted to properties
  # @param options A hash of options to control properties file format
  # @return [String] A properties formatted string
  # @example Call the function with the $input hash
  #   hash2properties($input)
  dispatch :properties do
    param 'Hash', :input
    optional_param 'Hash', :options
  end

  def properties(input, options = {})
    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'key_val_separator' => '=',
      'quote_char'        => '',
      'list_separator'    => ',',
    }

    settings.merge!(options)

    properties_str = []
    key_hashes = input.to_a
    properties = {}
    list_separator = settings['list_separator']
    until key_hashes.empty?
      key_value = key_hashes.pop
      if key_value[1].is_a?(Hash)
        key_hashes += key_value[1].to_a.map { |key, value| ["#{key_value[0]}.#{key}", value] }
      else
        prop_value = if key_value[1].is_a?(Array)
                       key_value[1].join(list_separator)
                     else
                       prop_value = key_value[1]
                     end
        properties[key_value[0]] = prop_value
      end
    end

    key_val_separator = settings['key_val_separator']
    quote_char = settings['quote_char']

    properties.each do |property, value|
      properties_str << "#{property}#{key_val_separator}#{quote_char}#{value}#{quote_char}"
    end

    properties_str.sort! { |x, y| String(x) <=> String(y) }
    properties_str.insert(0, settings['header'], '')
    properties_str << ''

    properties_str.join("\n")
  end
end
