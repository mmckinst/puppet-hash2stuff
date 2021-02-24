# @summary Defined type provides an implementation of the hash2json function, creating a JSON file from the input hash
#
# A description of what this defined type does
#
# @example
#   hash2stuff::hash2json { 'namevar': }
define hash2stuff::hash2json (
  Hash $file_props,
  Hash $data_hash,
) {
  File {$name:
    * => merge($file_props, content => hash2json($data_hash)),
  }
}
