# Allow global must_* assertion style without deprecations
#
# Must be required before maxitest/autorun
#
# MT6: Global expectations were removed entirely, so we define them ourselves

require "minitest"
require "minitest/spec"

module Maxitest
  # Track current test instance for global must_* support
  def self.current_test
    Thread.current[:maxitest_current_test]
  end

  def self.current_test=(test)
    Thread.current[:maxitest_current_test] = test
  end
end

# Track the current test instance using prepend on run (grosser's MT6 fix)
Minitest::Test.prepend(Module.new do
  def run
    Maxitest.current_test = self
    super
  ensure
    Maxitest.current_test = nil
  end
end)

# Define global must_* methods on Object
# This mimics what MT5's infect_an_assertion used to do
expectation_methods = Minitest::Expectation.instance_methods - Object.instance_methods
expectation_methods.grep(/^must_|^wont_/).each do |meth|
  Object.define_method(meth) do |*args, &block|
    ctx = Maxitest.current_test
    raise "Global must_*/wont_* called outside of test context" unless ctx
    Minitest::Expectation.new(self, ctx).public_send(meth, *args, &block)
  end
end
