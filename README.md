[![Build Status](https://travis-ci.org/mmckinst/puppet-hash2stuff.svg?branch=master)](https://travis-ci.org/mmckinst/puppet-hash2stuff)
[![Puppet Forge version](https://img.shields.io/puppetforge/v/mmckinst/hash2stuff.svg)](https://forge.puppet.com/mmckinst/hash2stuff)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/mmckinst/hash2stuff.svg)](https://forge.puppet.com/mmckinst/hash2stuff)


# Deprecation

Originally these functions were rejected for inclusion to [puppetlab's
stdlib](https://github.com/puppetlabs/puppetlabs-stdlib). Now equivalent
functions have been added there making these unnecessary.

## hash2ini

This has been moved to [voxpupuli's
extlib](https://github.com/voxpupuli/puppet-extlib) starting with [v6.2.0
released February 28
2023](https://github.com/voxpupuli/puppet-extlib/blob/master/CHANGELOG.md#v620-2023-02-28)

## hash2json

There is a `to_json` and a `to_json_pretty` function in [puppetlab's stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
starting with [version 4.20.0 released September 11
2017](https://github.com/puppetlabs/puppetlabs-stdlib/blob/main/CHANGELOG.md#4200---2017-09-11)

## hash2kv

There is a `join_keys_to_values` function in [puppetlab's
stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) that [has been there
since
2012](https://github.com/puppetlabs/puppetlabs-stdlib/commit/ee0f2b307d79f145d875d02d98e570fd3e7f156c).

## hash2properties

There is no equivalent I've found.

## hash2yaml

There is a `to_yaml` function in [puppetlab's
stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) starting with [version
4.20.0 released September 11
2017](https://github.com/puppetlabs/puppetlabs-stdlib/blob/main/CHANGELOG.md#4200---2017-09-11)
