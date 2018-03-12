# tests that leave extra threads running can break other threads in weird ways ... prevent that from happening
module Maxitest
  module Threads
    def setup
      @maxitest_threads_before = Thread.list
      super
    end

    def teardown
      super
      found = maxitest_extra_threads
      raise "Test left #{found.size} extra threads" if found.any?
    ensure
      maxitest_kill_extra_threads
    end

    def maxitest_wait_for_extra_threads
      sleep 0.01 while maxitest_extra_threads.any?
    end

    def maxitest_kill_extra_threads
      maxitest_extra_threads.map(&:kill).map(&:join)
    end

    def maxitest_extra_threads
      Thread.list - @maxitest_threads_before
    end
  end
end

Minitest::Test.send :prepend, Maxitest::Threads


