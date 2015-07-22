# Be sure to restart your server when you modify this file.

BootstrapNavbar.configure do |config|
  config.bootstrap_version = '3.3.5'
  config.current_url_method = 'request.original_url'
end

module BootstrapNavbar::Helpers
  def prepare_html(html)
    html.html_safe
  end
end

ActionView::Base.send :include, BootstrapNavbar::Helpers
