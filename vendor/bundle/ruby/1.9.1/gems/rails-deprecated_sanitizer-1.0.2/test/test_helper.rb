require 'bundler/setup'
require 'minitest/autorun'
require 'active_support'
require 'active_support/test_case'
require 'active_support/testing/autorun'

require 'rails/deprecated_sanitizer'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true
