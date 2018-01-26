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
      # only things with class `Minitest::Skip` get counted as skips
      # we need to raise and capture to get a skip with a backtrace
      skip = begin
        raise Minitest::Skip, "Maxitest::Interrupted"
      rescue Minitest::Skip
        $!
      end
      self.failures = [skip]
      defined?(Minitest::Result) ? Minitest::Result.from(self) : self
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
