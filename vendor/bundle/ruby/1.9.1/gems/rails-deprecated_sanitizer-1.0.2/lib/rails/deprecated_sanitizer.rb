require "rails/deprecated_sanitizer/version"
require "rails/deprecated_sanitizer/html-scanner"
require "rails/deprecated_sanitizer/railtie"

module Rails
  module DeprecatedSanitizer
    extend self

    def full_sanitizer
      HTML::FullSanitizer
    end

    def link_sanitizer
      HTML::LinkSanitizer
    end

    def white_list_sanitizer
      HTML::WhiteListSanitizer
    end
  end
end

module ActionView
  module Helpers
    module SanitizeHelper
      extend self

      if method_defined?(:sanitizer_vendor) || private_method_defined?(:sanitizer_vendor)
        undef_method(:sanitizer_vendor)
      end

      def sanitizer_vendor
        Rails::DeprecatedSanitizer
      end

      def sanitized_protocol_separator
        white_list_sanitizer.protocol_separator
      end

      def sanitized_uri_attributes
        white_list_sanitizer.uri_attributes
      end

      def sanitized_bad_tags
        white_list_sanitizer.bad_tags
      end

      def sanitized_allowed_tags
        white_list_sanitizer.allowed_tags
      end

      def sanitized_allowed_attributes
        white_list_sanitizer.allowed_attributes
      end

      def sanitized_allowed_css_properties
        white_list_sanitizer.allowed_css_properties
      end

      def sanitized_allowed_css_keywords
        white_list_sanitizer.allowed_css_keywords
      end

      def sanitized_shorthand_css_properties
        white_list_sanitizer.shorthand_css_properties
      end

      def sanitized_allowed_protocols
        white_list_sanitizer.allowed_protocols
      end

      def sanitized_protocol_separator=(value)
        white_list_sanitizer.protocol_separator = value
      end

      # Adds valid HTML attributes that the +sanitize+ helper checks for URIs.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_uri_attributes = 'lowsrc', 'target'
      #   end
      #
      def sanitized_uri_attributes=(attributes)
        HTML::WhiteListSanitizer.uri_attributes.merge(attributes)
      end

      # Adds to the Set of 'bad' tags for the +sanitize+ helper.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_bad_tags = 'embed', 'object'
      #   end
      #
      def sanitized_bad_tags=(attributes)
        HTML::WhiteListSanitizer.bad_tags.merge(attributes)
      end

      # Adds to the Set of allowed tags for the +sanitize+ helper.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'
      #   end
      #
      def sanitized_allowed_tags=(attributes)
        HTML::WhiteListSanitizer.allowed_tags.merge(attributes)
      end

      # Adds to the Set of allowed HTML attributes for the +sanitize+ helper.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_allowed_attributes = ['onclick', 'longdesc']
      #   end
      #
      def sanitized_allowed_attributes=(attributes)
        HTML::WhiteListSanitizer.allowed_attributes.merge(attributes)
      end

      # Adds to the Set of allowed CSS properties for the #sanitize and +sanitize_css+ helpers.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_allowed_css_properties = 'expression'
      #   end
      #
      def sanitized_allowed_css_properties=(attributes)
        HTML::WhiteListSanitizer.allowed_css_properties.merge(attributes)
      end

      # Adds to the Set of allowed CSS keywords for the +sanitize+ and +sanitize_css+ helpers.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_allowed_css_keywords = 'expression'
      #   end
      #
      def sanitized_allowed_css_keywords=(attributes)
        HTML::WhiteListSanitizer.allowed_css_keywords.merge(attributes)
      end

      # Adds to the Set of allowed shorthand CSS properties for the +sanitize+ and +sanitize_css+ helpers.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_shorthand_css_properties = 'expression'
      #   end
      #
      def sanitized_shorthand_css_properties=(attributes)
        HTML::WhiteListSanitizer.shorthand_css_properties.merge(attributes)
      end

      # Adds to the Set of allowed protocols for the +sanitize+ helper.
      #
      #   class Application < Rails::Application
      #     config.action_view.sanitized_allowed_protocols = 'ssh', 'feed'
      #   end
      #
      def sanitized_allowed_protocols=(attributes)
        HTML::WhiteListSanitizer.allowed_protocols.merge(attributes)
      end
    end
  end
end
