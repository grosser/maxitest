module Maxitest::VerboseBacktrace
  class NullFilter
    def self.filter(backtrace)
      backtrace
    end
  end

  class << self
    attr_accessor :verbose
  end

  def plugin_maxitest_verbose_backtrace_init(options)
    return unless options[:verbose]
    Maxitest::VerboseBacktrace.verbose = true
    Minitest.backtrace_filter = Maxitest::VerboseBacktrace::NullFilter
  end
end

Minitest.extensions << 'maxitest_verbose_backtrace'
Minitest.extend Maxitest::VerboseBacktrace

module Maxitest::VerboseAssertion
  def message
    if Maxitest::VerboseBacktrace.verbose
      "#{self.class}: #{super}\n    #{backtrace.join "\n    "}"
    else
      super
    end
  end
end

Minitest::Assertion.send(:include, Maxitest::VerboseAssertion)
