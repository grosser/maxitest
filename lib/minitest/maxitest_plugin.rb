# we are not enabling our extensions unless maxitest/autorun was loaded
# minitest plugin system auto-loads all files in the load path and that would
# always enable all our plugins even if they were not wanted
if defined?(Maxitest::ENABLE_PLUGINS) && Maxitest::ENABLE_PLUGINS
  # rails has --backtrace which disables rails own backtrace cleaner, but not minitests
  require "maxitest/verbose_backtrace"
end
