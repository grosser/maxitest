require "minitest"

if $stdout.tty?
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg!
end

require "maxitest/verbose_backtrace"

require "maxitest/vendor/line"
Minitest.extensions << "line"

require "minitest/autorun"
require "maxitest/around"
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
