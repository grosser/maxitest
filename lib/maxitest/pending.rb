module Maxitest
  module Pending
    def pending(reason=nil, **kwargs)
      raise ArgumentError, "Need a block to execute" unless block_given?
      raise ArgumentError, "Only :if option is supported" if (kwargs.keys | [:if] != [:if])
      return yield if kwargs.fetch(:if, true) == false # allow user to for example mark test only pending on CI with `if: ENV["CI"]`

      begin
        yield # execute test
      rescue StandardError, Minitest::Assertion
        skip reason # test failed as expected
      else
        flunk "Test is fixed, remove `pending`"
      end
    end
  end
end

Minitest::Test.send(:include, Maxitest::Pending)
