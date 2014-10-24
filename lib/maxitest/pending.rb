module Maxitest
  module Pending
    def pending(reason=nil)
      yield
    rescue Minitest::Assertion
      skip reason
    else
      raise "Fixed"
    end
  end
end

Minitest::Test.send(:include, Maxitest::Pending)
