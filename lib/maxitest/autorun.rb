require "minitest"
require "minitest/autorun"
require "maxitest/vendor/around"
require "maxitest/interrupt" unless ENV["MAXITEST_NO_INTERRUPT"]
require "maxitest/let_bang"
require "maxitest/let_all"
require "maxitest/hook_all"
require "maxitest/pending"
require "maxitest/helpers"
require "maxitest/xit"
require "maxitest/static_class_order"
require "maxitest/shorted_backtrace"
require "maxitest/verbose_backtrace"

module Maxitest
end

unless Gem::Specification.find_all_by_name("rails").any? # rails adds default red/green output
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg! $stdout.tty?
end

Minitest::Spec::DSL.send(:alias_method, :context, :describe)

class << Minitest::Test
  alias_method :order_dependent!, :i_suck_and_my_tests_are_order_dependent!
end

# do not show maxitest as causing errors, but the last line in the users code
old = Minitest::BacktraceFilter::MT_RE
Minitest::BacktraceFilter.send(:remove_const, :MT_RE)
Minitest::BacktraceFilter::MT_RE = Regexp.union(old, %r%lib/maxitest%)
