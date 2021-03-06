require 'erb'
include ERB::Util

# A simple way to add helpers via a plugin
# this could be broken out in several way...
# for example, you could put the helper in its own file an require_relative to that file

module UMDLibEnvironmentBannerHelper
  # https://confluence.umd.edu/display/LIB/Create+Environment+Banners
  def umd_lib_environment_banner
    current_env = environment_name
    if current_env
      text = "#{current_env} Environment"
      id = "environment-#{current_env.downcase}"
      "<div class='environment-banner' id='#{html_escape(id)}'>#{html_escape(text)}</div>".html_safe
    end
  end

  def environment_name
    return 'Local' if Rails.env.development? || Rails.env.vagrant?
    hostname = `hostname -s`
    return 'Development' if hostname =~ /dev$/
    return 'Staging' if hostname =~ /stage$/
  end
end

# here we reopen the ApplicationController (after Rails has started)
# and stick in our helper module.
Rails.application.config.after_initialize do
    ApplicationController.class_eval do
      include UMDLibEnvironmentBannerHelper
      helper_method :umd_lib_environment_banner
    end
end
