# frozen_string_literal: true

module Maxitest
  Interrupted = Class.new(StandardError)
  class << self
    attr_accessor :interrupted
  end

  module InterruptHandler
    def capture_exceptions(&block)
      super(&block)
    rescue Interrupt => e
      Maxitest.interrupted = true
      failures << Minitest::UnexpectedError.new(e)
    end

    def run
      if Maxitest.interrupted
        skip = begin
          raise Minitest::Skip, 'Maxitest::Interrupted'
        rescue Minitest::Skip => e
          e
        end
        self.failures = [skip]
        defined?(Minitest::Result) ? Minitest::Result.from(self) : self
      else
        super()
      end
    end
  end
end

Minitest::Test.prepend(Maxitest::InterruptHandler)
