# frozen_string_literal: true
module Maxitest
  module VerboseBacktrace
    class NullFilter
      def self.filter(backtrace)
        backtrace
      end
    end

    # when printing messages print more if verbose was enabled
    module Assertion
      def message
        if Maxitest::VerboseBacktrace.enabled
          "#{self.class}: #{super}\n    #{backtrace.join "\n    "}"
        else
          super
        end
      end
    end

    module MinitestPlugin
      def self.minitest_plugin_init(options)
        return unless options[:verbose]
        Maxitest::VerboseBacktrace.enabled = true
        Minitest.backtrace_filter = Maxitest::VerboseBacktrace::NullFilter
        # rails has --backtrace which disables rails own backtrace cleaner, but not minitests
        Rails.backtrace_cleaner.remove_silencers! if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner)
      end
    end

    class << self
      attr_accessor :enabled
    end
  end
end

Minitest::Assertion.include Maxitest::VerboseBacktrace::Assertion
