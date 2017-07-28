source 'https://rubygems.org'

group :tests do
  # puppetlabs_spec_helper stopped testing ruby 1.9.3 with 2.3.0. pin to < 2.0.0
  # if using ruby 1.x for puppet 3.2 through puppet 3.4
  #
  # https://github.com/puppetlabs/puppetlabs_spec_helper/commit/4f1c7457b06cb854a9682d602cab055f4bb05bc7
  gem 'puppetlabs_spec_helper', '~>2.2.0', :require => false if RUBY_VERSION =~ /^1\./
  gem 'puppet-lint', '~>2.0'
  gem 'puppet-lint-unquoted_string-check'
  gem 'puppet-lint-empty_string-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-variable_contains_upcase'
  gem 'puppet-lint-version_comparison-check'
  gem 'rspec'
  gem 'rspec-puppet'
  gem 'rspec-puppet-facts'

  # metadata-json-lint 1.0.0 was the last version to support ruby 1.9.3. pin
  # to < 2.0.0 if using ruby 1.x for puppet 3.2 through puppet 3.4
  #
  # https://github.com/voxpupuli/metadata-json-lint/pull/75#issuecomment-308243700
  gem 'metadata-json-lint', '<=1.0.0', :require => false if RUBY_VERSION =~ /^1\./
end

# json_pure 2.0.2 added a requirement on ruby >= 2. We pin to json_pure 2.0.1
# if using ruby 1.x for puppet 3.2 through puppet 3.4
gem 'json', '~>1.8', :require => false if RUBY_VERSION =~ /^1\./
gem 'json_pure', '<=2.0.1', :require => false if RUBY_VERSION =~ /^1\./

# public_suffix 1.5.0 dropped ruby < 2.0. pin to 1.4.x if using ruby 1.x for
# puppet 3.2 through puppet 3.4
gem 'public_suffix', '~>1.4.0', :require => false if RUBY_VERSION =~ /^1\./


group :development do
  gem "puppet-blacksmith"
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
