require "minitest"

if $stdout.tty?
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg!
end

require "maxitest/vendor/line"
Minitest.extensions << "line"

require "minitest/autorun"
require "maxitest/vendor/around"

Minitest::Spec::DSL.class_eval do
  alias_method :context, :describe

  def let!(name, &block)
    let(name, &block)
    before { send(name) }
  end
end

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
