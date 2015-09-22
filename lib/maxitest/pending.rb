module Maxitest
  module Pending
    def pending(reason=nil)
      if block_given?
        begin
          yield
        rescue StandardError, Minitest::Assertion
          skip reason
        else
          raise "Fixed"
        end
      else
        raise ArgumentError, "Need a block to execute"
      end
    end
  end
end

Minitest::Test.send(:include, Maxitest::Pending)
