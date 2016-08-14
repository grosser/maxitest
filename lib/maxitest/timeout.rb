# tests sometimes hang locally or on ci and with this we can actually debug the cause instead of just hanging forever
require 'timeout'

module Maxitest
  class << self
    attr_accessor :timeout
  end

  module Timeout
    class TestCaseTimeout < StandardError
      def message
        "Test took too long to finish, aborting. To use a debugger, set Maxitest.timeout = false at the top of the test file."
      end
    end

    def capture_exceptions(*, &block)
      if Maxitest.timeout == false
        super
      else
        super do
          rescued = false
          begin
            ::Timeout.timeout(Maxitest.timeout || 5, TestCaseTimeout, &block)
          rescue TestCaseTimeout => e
            raise e if rescued
            rescued = true
            retry
          end
        end
      end
    end
  end
end

Minitest::Test.send :prepend, Maxitest::Timeout


