# @summary Provide an entry point for module defined types.  The class does nothing without hiera data
#
class hash2stuff  (
  Hash $hash2ini = {},
  Hash $hash2json = {},
  Hash $hash2kv = {},
  Hash $hash2properties = {},
  Hash $hash2yaml = {},
) {
  # Create resources from parameter hashes using the defined types
  $hash2ini.each        |$name, $hash| { Resource['Hash2stuff::Hash2ini']        { $name: * => $hash, } }
  $hash2json.each       |$name, $hash| { Resource['Hash2stuff::Hash2json']       { $name: * => $hash, } }
  $hash2kv.each         |$name, $hash| { Resource['Hash2stuff::Hash2kv']         { $name: * => $hash, } }
  $hash2properties.each |$name, $hash| { Resource['Hash2stuff::Hash2properties'] { $name: * => $hash, } }
  $hash2yaml.each       |$name, $hash| { Resource['Hash2stuff::Hash2yaml']       { $name: * => $hash, } }
}
