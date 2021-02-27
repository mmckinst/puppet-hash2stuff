[![Build Status](https://travis-ci.org/mmckinst/puppet-hash2stuff.svg?branch=master)](https://travis-ci.org/mmckinst/puppet-hash2stuff)
[![Puppet Forge version](https://img.shields.io/puppetforge/v/mmckinst/hash2stuff.svg)](https://forge.puppet.com/mmckinst/hash2stuff)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/mmckinst/hash2stuff.svg)](https://forge.puppet.com/mmckinst/hash2stuff)

## Overview

This module will convert puppet hashes in to different formats commonly used for
config files. It is used to overwrite an entire config file with one from
puppet, if you are trying to manage bits and pieces of a config file, you want
to use something like
[puppetlabs/inifile](https://github.com/puppetlabs/puppetlabs-inifile) or
[augeas](https://docs.puppet.com/guides/augeas.html).

## Usage

The value of the module is in the custom functions that convert the input hash to the
specified output format.  Defined types have been added to implement each function so
they can be used from hiera without writing more puppet manifests.  See the reference
for details on the defined types.  The core functions are documented in detail here.

### `hash2ini`

Converts a hash into an
[INI file format](https://en.wikipedia.org/wiki/INI_file). *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an INI file, you want
[puppetlabs/inifile](https://github.com/puppetlabs/puppetlabs-inifile).

#### Parameters

It accepts the following optional parameters passed to it in a hash as the second argument:

* `header`: String you want at the top of the file saying it is controlled by puppet. Default: '# THIS FILE IS CONTROLLED BY PUPPET'
* `section_prefix`: String that will appear before the section's name. Default: '['
* `section_suffix`: String that will appear after the section's name. Default: ']'
* `key_val_separator`: String to use between setting name and value (e.g., to determine whether the separator includes whitespace). Default: '='.
* `quote_char`: Character or string to quote the entire value of the setting. Default: '"'

For example:

```puppet
$config = {
  'main' => {
    'logging' => 'INFO',
    'limit'   => 314,
    'awesome' => true,
  },
  'dev' => {
    'logging'      => 'DEBUG',
    'log_location' => '/var/log/dev.log',
  }
}

file {'/etc/config.ini':
  ensure  => 'present',
  content => hash2ini($config)
}
```

will produce a file at /etc/config.ini that looks like:

```ini
# THIS FILE IS CONTROLLED BY PUPPET

[main]
logging="INFO"
limit="314"
awesome="true"

[dev]
logging="DEBUG"
log_location="/var/log/dev.log"
```

Or you can specify custom settings:

```puppet
$settings = {
  'header'            => '; THIS FILE IS CONTROLLED BY PUPPET',
  'key_val_separator' => ' = ',
  'quote_char'        => '',
}

$php_config = {
  'PHP' => {
    'engine'                  => 'On',
    'realpath_cache_size'     => '32k',
    'zlib.output_compression' => 'On',
    'expose_php'              => 'Off',
  },
  'Date' => {
    'date.timezone'           => '"America/Detroit"',
  }
}

file {'/etc/php.ini':
  ensure  => 'present',
  content => hash2ini($php_config, $settings)
}
```

will produce a file at /etc/php.ini that looks like:

```ini
; THIS FILE IS CONTROLLED BY PUPPET

[PHP]
engine = On
realpath_cache_size = 32k
zlib.output_compression = On
expose_php = Off

[Date]
date.timezone = "America/Detroit"
```

### `hash2json`

This function overlaps with
[to_json](https://forge.puppet.com/puppetlabs/stdlib#to_json) and
[to_json_pretty](https://forge.puppet.com/puppetlabs/stdlib#to_json_pretty) from
[puppetlab's stdlib](https://forge.puppet.com/puppetlabs/stdlib).

Converts a hash into a JSON string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an JSON file, you want
[augeas](https://docs.puppet.com/guides/augeas.html) with the
[JSON lens](https://github.com/hercules-team/augeas/blob/master/lenses/json.aug).

For example:

```puppet
$config = {
  'domain' => 'example.com',
  'mysql'  => {
    'hosts' => ['192.0.2.2', '192.0.2.4'],
    'user'  => 'root',
    'pass'  => 'setec-astronomy',
  },
  'awesome' => true,
}

file {'/etc/config.json':
  ensure  => 'present',
  content => hash2json($config)
}
```

will produce a file at /etc/config.json that looks like:

```json
{
  "domain": "example.com",
  "mysql": {
    "hosts": [
      "192.0.2.2",
      "192.0.2.4"
    ],
    "user": "root",
    "pass": "setec-astronomy"
  },
  "awesome": true
}
```

### `hash2kv`

Converts a hash into an key-value/shellvar string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an key-value/shellvar style file, you
probably want
[herculesteam/augeasproviders_shellvar](https://forge.puppet.com/herculesteam/augeasproviders_shellvar).

#### Parameters

It accepts the following optional parameters passed to it in a hash as the second argument:

* `header`: String you want at the top of the file saying it is controlled by puppet. Default: '# THIS FILE IS CONTROLLED BY PUPPET'.
* `key_val_separator`: String to use between setting name and value (e.g., to determine whether the separator includes whitespace). Default: '='.
* `quote_char`: Character or string to quote the entire value of the setting. Default: '"'.
* `quote_booleans`: A boolean controlling whether or not to quote boolean values. Default: 'true'.
* `quote_numerics`: A boolean controlling whether or not to quote numeric values. Default: 'true'.

For example:

```puppet
$config = {
  'HOSTNAME'     => 'foo.example.com',
  'RSYNC_IONICE' => '3',
  'PORTS'        => '53 123 80',
}

file {'/etc/config.sh':
  ensure  => 'present',
  content => hash2kv($config)
}
```

will produce a file at /etc/config.sh that looks like:

```shell
# THIS FILE IS CONTROLLED BY PUPPET

HOSTNAME="foo.example.com"
RSYNC_IONICE="3"
PORTS="53 123 80"
```

Or you can specify custom settings:

```puppet
$settings = {
  'header'            => '; THIS FILE IS CONTROLLED BY PUPPET',
  'key_val_separator' => ': ',
  'quote_char'        => '',
}

$config = {
  'HOSTNAME'     => 'foo.example.com',
  'RSYNC_IONICE' => '3',
  'PORTS'        => '53 123 80',
}

file {'/etc/config.kv':
  ensure  => 'present',
  content => hash2kv($php_config, $settings)
}
```

will produce a file at /etc/config.kv that looks like:

```
; THIS FILE IS CONTROLLED BY /dev/random

HOSTNAME: foo.example.com
RSYNC_IONICE: 3
PORTS: 53 123 80
```

### `hash2properties`

Converts a hash into a Java properties file. *Type*: rvalue.

#### Parameters

It accepts the following optional parameters passed to it in a hash as the second argument:

* `header`: String you want at the top of the file saying it is controlled by puppet. Default: '# THIS FILE IS CONTROLLED BY PUPPET'.
* `key_val_separator`: String to use between setting name and value (e.g., to determine whether the separator includes whitespace). Default: '='.
* `quote_char`: Character or string to quote the entire value of the setting. Default: '"'.
* `list_separator`: Character to separate lists

For example:

```puppet
$config = {
  'main' => {
    'logging' => 'INFO',
    'limit'   => 314,
    'awesome' => true,
    'nested'  => {
      'sublevel1' => 'value1',
      'subnested1' => {
        'node1' => 'leaf1',
        'node2' => 'leaf2',
      },
      'list' => [
        'item1',
        'item2',
      ]
    }
  },
  'dev' => {
    'logging'      => 'DEBUG',
    'log_location' => '/var/log/dev.log',
  }
}


file {'/etc/config.properties':
  ensure  => 'present',
  content => hash2properties($config)
}
```

will produce a file at /etc/config.properties that looks like:

```shell
# THIS FILE IS CONTROLLED BY PUPPET

dev.log_location=/var/log/dev.log
dev.logging=DEBUG
main.awesome=true
main.limit=314
main.logging=INFO
main.nested.list=item1,item2
main.nested.sublevel1=value1
main.nested.subnested1.node1=leaf1
main.nested.subnested1.node2=leaf2
```

Or you can specify custom settings:

```puppet
settings = {
  'header'            => '# THIS FILE IS CONTROLLED BY /dev/random',
  'key_val_separator' => ': ',
  'quote_char'        => '"',
}

$config = {
  'main' => {
    'logging' => 'INFO',
    'limit'   => 314,
    'awesome' => true,
    'nested'  => {
      'sublevel1' => 'value1',
      'subnested1' => {
        'node1' => 'leaf1',
        'node2' => 'leaf2',
      },
      'list' => [
        'item1',
        'item2',
      ]
    }
  },
  'dev' => {
    'logging'      => 'DEBUG',
    'log_location' => '/var/log/dev.log',
  }
}

file {'/etc/config.properties':
  ensure  => 'present',
  content => hash2properites($config, $settings)
}
```

will produce a file at /etc/config.properties that looks like:

```
# THIS FILE IS CONTROLLED BY /dev/random

dev.log_location: "/var/log/dev.log"
dev.logging: "DEBUG"
main.awesome: "true"
main.limit: "314"
main.logging: "INFO"
main.nested.list: "item1,item2"
main.nested.sublevel1: "value1"
main.nested.subnested1.node1: "leaf1"
main.nested.subnested1.node2: "leaf2"
```

### `hash2yaml`

This function overlaps with
[to_yaml](https://forge.puppet.com/puppetlabs/stdlib#to_yaml) from [puppetlab's
stdlib](https://forge.puppet.com/puppetlabs/stdlib). This function does provide
a header option to give a string saying the file is controlled by puppet.

Converts a hash into a YAML string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an YAML file, you want
[augeas](https://docs.puppet.com/guides/augeas.html) with the
[YAML lens](https://github.com/hercules-team/augeas/blob/master/lenses/yaml.aug).

#### Parameters

It accepts the following optional parameters passed to it in a hash as the second argument:

* `header`: String you want at the top of the file saying it is controlled by puppet. Default: '""'.

For example:

```puppet
$config = {
  'domain' => 'example.com',
  'mysql'  => {
    'hosts' => ['192.0.2.2', '192.0.2.4'],
    'user'  => 'root',
    'pass'  => 'setec-astronomy',
  },
  'awesome' => true,
}

file {'/etc/config.yaml':
  ensure  => 'present',
  content => hash2yaml($config)
}
```

will produce a file at /etc/config.yaml that looks like:

```yaml
---
domain: example.com
mysql:
  hosts:
  - 192.0.2.2
  - 192.0.2.4
  user: root
  pass: setec-astronomy
awesome: true
```

Or you can specify custom settings:

```puppet
$settings = {
  'header' => '# THIS FILE IS CONTROLLED BY PUPPET',
}

$config = {
  'domain' => 'example.com',
  'mysql'  => {
    'hosts' => ['192.0.2.2', '192.0.2.4'],
    'user'  => 'root',
    'pass'  => 'setec-astronomy',
  },
  'awesome' => true,
}

file {'/etc/config.yaml':
  ensure  => 'present',
  content => hash2yaml($config, $settings)
}
```

That will produce a file at /etc/config.yaml that looks like:

```yaml
# THIS FILE IS CONTROLLED BY PUPPET
---
domain: example.com
mysql:
  hosts:
  - 192.0.2.2
  - 192.0.2.4
  user: root
  pass: setec-astronomy
awesome: true
```

Puppet 3.x renders YAML differently than puppet 4.x (different whitespacing,
quotes around some strings, etc), although they look slightly different they are
the same when parsed by a YAML library.

Copyright
---

```
Copyright 2016 Mark McKinstry

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
