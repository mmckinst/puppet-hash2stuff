[![Build Status](https://travis-ci.org/mmckinst/puppet-hash2stuff.svg?branch=master)](https://travis-ci.org/mmckinst/puppet-hash2stuff)

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
  settings = {
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
