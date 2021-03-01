# @summary
#   Defined type provides an implementation of the hash2ini function, creating an INI file from the input hash
#
# @param file_props
#   Properties of the target file resource.  Accepts and requires the same parameters of a puppet "file"
#  
# @param data_hash
#   Hash representation of the INI file, to include section names and key/value pairs
#
# @param options
#   Hash of optional values to pass to the "hash2ini" function.  See the function for details.
#
# @example
#   hash2stuff::hash2ini { 'namevar':
#     file_props => {
#       ensure => file,
#       owner  => 'root',
#       group  => 'root',
#       mode   => '0644',
#     }
#     data_hash  => {
#       section1 => {
#         key1   => 'value1',
#       }
#     }
#   }
#
define hash2stuff::hash2ini (
  Hash $file_props,
  Hash $data_hash,
  Hash $options = {},
) {
  File {$name:
    * => merge($file_props, content => hash2ini($data_hash, $options)),
  }
}
