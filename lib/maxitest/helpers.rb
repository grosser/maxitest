# frozen_string_literal: true
module Maxitest
  module Helpers
    module InstanceMethods
      def with_env(env)
        _synchronize do
          old = ENV.to_h
          env.each { |k, v| ENV[k.to_s] = v }
          yield
        ensure
          ENV.replace old
        end
      end

      # stripped down version of capture_io
      def capture_stdout
        _synchronize do
          captured_stdout = StringIO.new
          orig_stdout = $stdout
          $stdout = captured_stdout
          yield
          return captured_stdout.string
        ensure
          $stdout = orig_stdout
        end
      end

      # stripped down version of capture_io
      def capture_stderr
        _synchronize do
          captured_stderr = StringIO.new
          orig_stderr = $stderr
          $stderr = captured_stderr
          yield
          return captured_stderr.string
        ensure
          $stderr = orig_stderr
        end
      end
    end

    module ClassMethods
      def with_env(env)
        around { |t| with_env(env, &t) }
      end
    end
  end
end

Minitest::Test.include Maxitest::Helpers::InstanceMethods
Minitest::Test.extend Maxitest::Helpers::ClassMethods
