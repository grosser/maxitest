Minitest::Test.class_eval do
  alias_method :capture_exceptions_without_stop, :capture_exceptions
  def capture_exceptions(&block)
    capture_exceptions_without_stop(&block)
  rescue Interrupt
    Maxitest.interrupted = true
    self.failures << Minitest::UnexpectedError.new($!)
  end

  alias_method :run_without_stop, :run
  def run
    if Maxitest.interrupted
      self.failures = [Minitest::Skip.new("Maxitest::Interrupted")]
      self
    else
      run_without_stop
    end
  end
end

module Maxitest
  Interrupted = Class.new(StandardError)
  class << self
    attr_accessor :interrupted
  end
end
