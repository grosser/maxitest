Minitest::Test.class_eval do
  alias_method :run_without_stop, :run
  def run
    if Maxitest.interrupted
      self.failures = [Minitest::Skip.new("Maxitest::Interrupted")]
    else
      run_without_stop
    end
    self
  end
end

module Maxitest
  Interrupted = Class.new(StandardError)
  class << self
    attr_accessor :interrupted

    def interrupt
      Maxitest.interrupted = true
      raise Maxitest::Interrupted, "Execution interrupted by user"
    end
  end
end

Signal.trap(:SIGINT) { Maxitest.interrupt }
