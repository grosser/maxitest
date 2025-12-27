# frozen_string_literal: true

# - show current backtrace when interrupting a stuck test with Ctrl+c
# - skip remaining tests

module Maxitest
  Interrupted = Class.new(StandardError)
  class << self
    attr_accessor :interrupted
  end

  module InterruptHandler
    # capture interrupt and treat it as a regular error so we get a backtrace
    def capture_exceptions(&block)
      super
    rescue Interrupt => e
      Maxitest.interrupted = true
      failures << Minitest::UnexpectedError.new(e)
    end

    # skip remaining tests if we were interrupted
    def run
      if Maxitest.interrupted
        # produce a real error so we do not crash in -v mode
        failures <<
          begin
            raise Minitest::Skip, 'Maxitest::Interrupted'
          rescue Minitest::Skip
            $!
          end
        result = Minitest::Result.from(self)
        result.time = 0
        result
      else
        super
      end
    end
  end
end

Minitest::Test.prepend(Maxitest::InterruptHandler)
