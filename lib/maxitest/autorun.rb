require "minitest"

if $stdout.tty?
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg!
end

require "maxitest/vendor/line"
Minitest.extensions << "line"

require "minitest/autorun"
require "maxitest/vendor/around"
require "maxitest/trap"
require "maxitest/let_bang"
require "maxitest/pending"
require "maxitest/xit"

Minitest::Spec::DSL.send(:alias_method, :context, :describe)

class << Minitest::Test
  alias_method :order_dependent!, :i_suck_and_my_tests_are_order_dependent!
end
