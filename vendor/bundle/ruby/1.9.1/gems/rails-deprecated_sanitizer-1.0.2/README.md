# Rails::Deprecated::Sanitizer

In Rails 4.2 the sanitization implementation uses Loofah by default.
Previously html-scanner was used for this.
This gem includes that old behavior for easier migration and it will be supported until Rails 5.

If you need this behavior, add the gem to an applications gemfile, run `bundle` and the deprecated behavior is installed.

    gem 'rails-deprecated_sanitizer'

You can read more about the new behavior here: [rails-html-sanitizer](https://github.com/rails/rails-html-sanitizer).

# Reporting XSS Security Issues

The code provided here deals with XSS attacks and is therefore a security concern.
So if you find a security issue please follow the [regular security reporting guidelines](http://rubyonrails.org/security/).
