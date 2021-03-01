# @summary
#   Defined type provides an implementation of the hash2json function, creating a JSON file from the input hash
#
# @param file_props
#   Properties of the target file resource.  Accepts and requires the same parameters of a puppet "file"
#  
# @param data_hash
#   Hash representation of the JSON file.
#
# @example
#   hash2stuff::hash2json { 'namevar':
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
define hash2stuff::hash2json (
  Hash $file_props,
  Hash $data_hash,
) {
  File {$name:
    * => merge($file_props, content => hash2json($data_hash)),
  }
}
