# @summary Converts a puppet hash to YAML string.
Puppet::Functions.create_function(:hash2yaml) do
  # @param input The hash to be converted to YAML
  # @param options A hash of options to control YAML file format
  # @return [String] A YAML formatted string
  # @example Call the function with the $input hash
  #   hash2yaml($input)
  dispatch :yaml do
    param 'Hash', :input
    optional_param 'Hash', :options
  end

  require 'yaml'

  def yaml(input, options = {})
    settings = {
      'header' => '',
    }

    settings.merge!(options)

    output = if settings['header'].to_s.empty?
               input.to_yaml
             else
               "#{settings['header']}\n#{input.to_yaml}"
             end
    output
  end
end
