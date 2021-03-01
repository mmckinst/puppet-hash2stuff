# @summary Converts a puppet hash to JSON string.
Puppet::Functions.create_function(:hash2json) do
  # @param input The hash to be converted to JSON
  # @return [String] A JSON formatted string
  # @example Call the function with the $input hash
  #   hash2json($input)
  dispatch :json do
    param 'Hash', :input
  end

  require 'json'

  def json(input)
    JSON.pretty_generate(input) << "\n"
  end
end
