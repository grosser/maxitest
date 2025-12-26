# Allow .must_* and .wont_* assertions on all objects
# this was removed from minitest v6
#
# Must be required before maxitest/autorun

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

# Track the current test instance using prepend on run
Minitest::Test.prepend(
  Module.new do
    def run
      Maxitest.current_test = self
      super
    ensure
      Maxitest.current_test = nil
    end
  end
)

# Define global must_* methods on Object
# This mimics what mintest 5 infect_an_assertion used to do
expectation_methods = Minitest::Expectation.instance_methods - Object.instance_methods
expectation_methods.grep(/^must_|^wont_/).each do |meth|
  Object.define_method(meth) do |*args, &block|
    ctx = Maxitest.current_test ||
      raise(NotImplementedError, "Global #{meth} called outside of test context")
    Minitest::Expectation.new(self, ctx).public_send(meth, *args, &block)
  end
end
