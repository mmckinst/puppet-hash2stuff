[![Build Status](https://travis-ci.org/mmckinst/puppet-hash2stuff.svg?branch=master)](https://travis-ci.org/mmckinst/puppet-hash2stuff)

## Overview

This module will convert puppet hashes in to different formats commonly used for
config files. It is used to overwrite an entire config file with one from
puppet, if you are trying to manage bits and pieces of a config file, you want
to use something like
[puppetlabs/inifile](https://github.com/puppetlabs/puppetlabs-inifile) or
[augeas](https://docs.puppet.com/guides/augeas.html).

## Usage

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

~~~
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
~~~

will produce a file at /etc/config.ini that looks like:

~~~
# THIS FILE IS CONTROLLED BY PUPPET

[main]
logging="INFO"
limit="314"
awesome="true"

[dev]
logging="DEBUG"
log_location="/var/log/dev.log"
~~~

Or you can specify custom settings:

~~~
$settings = {
  'header'            => '; THIS FILE IS CONTROLLED BY PUPPET',
  'key_val_separator' => ' = ',
  'quote_char'        => '',
}

$php_config = {
  'PHP' => {
    'engine'				    => 'On',
    'realpath_cache_size'	    => '32k',
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
~~~

will produce a file at /etc/php.ini that looks like:

~~~
; THIS FILE IS CONTROLLED BY PUPPET

[PHP]
engine = On
realpath_cache_size = 32k
zlib.output_compression = On
expose_php = Off

[Date]
date.timezone = "America/Detroit"
~~~

### `hash2json`

Converts a hash into a JSON string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an JSON file, you want
[augeas](https://docs.puppet.com/guides/augeas.html) with the
[JSON lens](https://github.com/hercules-team/augeas/blob/master/lenses/json.aug).

For example:

~~~
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
~~~

will produce a file at /etc/config.json that looks like:

~~~
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
~~~

### `hash2kv`

Converts a hash into an key-value/shellvar string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an key-value/shellvar style file, you
probably want
[herculesteam/augeasproviders_shellvar](https://forge.puppet.com/herculesteam/augeasproviders_shellvar).

#### Parameters

It accepts the following optional parameters passed to it in a hash as the second argument:

* `header`: String you want at the top of the file saying it is controlled by puppet. Default: '# THIS FILE IS CONTROLLED BY PUPPET'
* `key_val_separator`: String to use between setting name and value (e.g., to determine whether the separator includes whitespace). Default: '='.
* `quote_char`: Character or string to quote the entire value of the setting. Default: '"'

For example:

~~~
$config = {
  'HOSTNAME'     => 'foo.example.com',
  'RSYNC_IONICE' => '3',
  'PORTS'        => '53 123 80',
}

file {'/etc/config.sh':
  ensure  => 'present',
  content => hash2kv($config)
}
~~~

will produce a file at /etc/config.sh that looks like:

~~~
# THIS FILE IS CONTROLLED BY PUPPET

HOSTNAME="foo.example.com"
RSYNC_IONICE="3"
PORTS="53 123 80"
~~~

Or you can specify custom settings:

~~~
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
~~~

will produce a file at /etc/config.kv that looks like:

~~~
; THIS FILE IS CONTROLLED BY /dev/random

HOSTNAME: foo.example.com
RSYNC_IONICE: 3
PORTS: 53 123 80
~~~

### `hash2yaml`

Converts a hash into a YAML string. *Type*: rvalue.

It is used when you want to overwrite an entire file with a hash of settings. If
you want to manage bits and pieces of an YAML file, you want
[augeas](https://docs.puppet.com/guides/augeas.html) with the
[YAML lens](https://github.com/hercules-team/augeas/blob/master/lenses/yaml.aug).

For example:

~~~
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
~~~

will produce a file at /etc/config.yaml that looks like:

~~~
---
domain: example.com
mysql:
  hosts:
  - 192.0.2.2
  - 192.0.2.4
  user: root
  pass: setec-astronomy
awesome: true
~~~

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
