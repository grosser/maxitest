# we are not enabling our extensions unless maxitest/autorun was loaded
# minitests plugin system auto-loads all files in the load path and that would
# always enable all our plugins even if they were not wanted
if defined?(Maxitest::ENABLE_PLUGINS) && Maxitest::ENABLE_PLUGINS
  disabled_for_rails = begin
    require 'rails/version'
    Rails::VERSION::MAJOR >= 5
  rescue LoadError
    false
  end

  # rails has --backtrace which disables rails own backtrace cleaner, but not minitests
  require "maxitest/verbose_backtrace"

  unless disabled_for_rails # rails 5 add default red/green output
    require "maxitest/vendor/rg"
    Minitest.extensions << "rg"
    Minitest::RG.rg! $stdout.tty?
  end

  unless disabled_for_rails # rails 5 breaks line support + has it's own line number runner
    require "maxitest/vendor/line"
    Minitest.extensions << "line"
  end
end
