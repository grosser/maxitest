# tests sometimes hang locally or on ci and with this we can actually debug the cause instead of just hanging forever
require 'timeout'

puts defined?(Maxitest::Timeout)

module Maxitest
  class << self
    attr_accessor :timeout
  end
end

module Maxitest::Timeout
    class TestCaseTimeout < StandardError
      def message
        "Test took too long to finish, aborting. To use a debugger, def maxitest_timeout;false;end in the test file."
      end
    end

    def run(*, &block)
      # NOTE: having a default def maxitest_timeout would break using let(:maxitest_timeout)
      timeout = (defined?(maxitest_timeout) ? maxitest_timeout : Maxitest.timeout || 5)
      if timeout == false
        super
      else
        begin
          ::Timeout.timeout(timeout, TestCaseTimeout) { super }
        rescue TestCaseTimeout => e
          failures << UnexpectedError.new(e)
        end
      end
    end
end

Minitest::Test.send :prepend, Maxitest::Timeout
