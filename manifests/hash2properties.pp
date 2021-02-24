# @summary Defined type provides an implementation of the hash2properties function, creating a Java properties file from the input hash
#
# @parameter file_props
#  Properties of the target file resource.  Accepts and requires the same parameters of a puppet "file"
#  
# @parameter data_hash
#   Hash representation of the INI file, to include section names and key/value pairs
#
# @parameter options
#   Hash of optional values to pass to the "hash2ini" function.  See function for details.
#
# @example
#   hash2stuff::hash2properties { 'namevar': }
define hash2stuff::hash2properties (
  Hash $file_props,
  Hash $data_hash,
  Hash $options = {},
) {
  File {$name:
    * => merge($file_props, content => hash2properties($data_hash, $options)),
  }
}
