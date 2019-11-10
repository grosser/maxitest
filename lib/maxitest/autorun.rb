require "minitest"
require "minitest/autorun"
require "maxitest/vendor/around"
require "maxitest/trap"
require "maxitest/let_bang"
require "maxitest/let_all"
require "maxitest/pending"
require "maxitest/xit"
require "maxitest/static_class_order"
require "maxitest/shorted_backtrace"
require "maxitest/vendor/line_describe" # not a plugin

module Maxitest
  ENABLE_PLUGINS = true
end

Minitest::Spec::DSL.send(:alias_method, :context, :describe)

class << Minitest::Test
  alias_method :order_dependent!, :i_suck_and_my_tests_are_order_dependent!
end
