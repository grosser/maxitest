require "minitest"

disabled_for_rails = begin
  require 'rails/version'
  Rails::VERSION::MAJOR >= 5
rescue LoadError
  ENV['MAXITEST_ENABLED_WITH_RAILS5'] # a way to get this back when on rails 5
end

if !disabled_for_rails && $stdout.tty? # rails 5 add default red/green output
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg!
end

require "maxitest/verbose_backtrace"

unless disabled_for_rails # rails 5 breaks line support + has it's own line number runner
  require "maxitest/vendor/line"
  Minitest.extensions << "line"
end

if disabled_for_rails
  require "minitest/spec"
else # rails 5 causes this to trigger a duplicate run
  require "minitest/autorun"
end
require "maxitest/vendor/around"
require "maxitest/trap"
require "maxitest/let_bang"
require "maxitest/let_all"
require "maxitest/pending"
require "maxitest/xit"
require "maxitest/static_class_order"

Minitest::Spec::DSL.send(:alias_method, :context, :describe)

class << Minitest::Test
  alias_method :order_dependent!, :i_suck_and_my_tests_are_order_dependent!
end
