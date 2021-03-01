# @summary Converts a puppet hash to key/value (SHELLVAR) file string.
Puppet::Functions.create_function(:hash2kv) do
  # @param input The hash to be converted to K/V file
  # @param options A hash of options to control K/V file format
  # @return [String] A K/V file formatted string
  # @example Call the function with the $input and $options hashes
  #   hash2ini($input, $options)
  dispatch :kv do
    param 'Hash', :input
    optional_param 'Hash', :options
  end

  def kv(input, options = {})
    settings = {
      'header'            => '# THIS FILE IS CONTROLLED BY PUPPET',
      'key_val_separator' => '=',
      'quote_char'        => '"',
    }

    settings.merge!(options)

    output = []
    output << settings['header'] << nil
    input.each do |k, v|
      output << "#{k}#{settings['key_val_separator']}#{settings['quote_char']}#{v}#{settings['quote_char']}"
    end
    output << nil
    output.join("\n")
  end
end
