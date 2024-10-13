require "spec_helper"
require 'open3'

describe Maxitest do
  it "has a VERSION" do
    Maxitest::VERSION.should =~ /^[\.\da-z]+$/
  end

  it "does not add extra output" do
    result = with_global_must do
      run_cmd("ruby spec/cases/plain.rb")
    end
    result.sub!(/seed \d+/, 'seed X')
    result.gsub!(/\d+\.\d+/, 'X')
    result.should == "Run options: --seed X\n\n# Running:\n\n..\n\nFinished in Xs, X runs/s, X assertions/s.\n\n2 runs, 2 assertions, 0 failures, 0 errors, 0 skips"
  end

  it "runs via ruby" do
    run_cmd("ruby spec/cases/plain.rb").should include "\n2 runs, 2 assertions"
  end

  it "supports context" do
    run_cmd("ruby spec/cases/context.rb").should include "\n2 runs, 2 assertions"
  end

  it "supports let!" do
    run_cmd("ruby spec/cases/let_bang.rb").should include "\n1 runs, 1 assertions"
  end

  it "supports let_all" do
    run_cmd("ruby spec/cases/let_all.rb")
  end

  it "can use static_class_order" do
    run_cmd("ruby spec/cases/static_class_order.rb").should include("\n0\n.0n\n.1\n.1n\n.2\n.2n\n.3\n.3n\n.4\n.4n\n.\n")
  end

  it "supports order_dependent" do
    run_cmd("ruby spec/cases/order_dependent.rb").should include "5 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
  end

  it "has pending" do
    run_cmd("ruby spec/cases/pending.rb")
  end

  it "does not call xit specs" do
    result = run_cmd("ruby spec/cases/xit.rb -v")
    result.should include "(no tests defined)"
    result.should include "4 runs, 3 assertions, 0 failures, 0 errors, 2 skips"
  end

  it "shows short backtraces" do
    out = run_cmd("ruby spec/cases/raise.rb", fail: true)

    # Ruby 3.2 has a different backtrace it add 2 lines between the lib/maxitest/timeout.rb
    # and the spec/cases/raise.rb
    out.gsub!(/\n.*previous definition of Timeout.*/, "")

    # unify backtraces between ruby versions
    output_in = out.gsub!(/:in .*/, "")

    output_in.should include "TypeError: Timeout is not a module"
    output_in.should include 'spec/cases/raise.rb:11'

    # Minitest 5.21.0+ backtrace is more verbose and the short backtrace feature seems to be gone
    # re-test by running spec/cases/raise.rb and only loading minitest/autorun and not maxitest
    if Minitest::VERSION <= "5.21.0"
      output_in.should_not include 'lib/maxitest'
    end
  end

  it "has helpers" do
    run_cmd("ruby spec/cases/helpers.rb")
  end

  it "does not use old MiniTest constant" do
    Dir["lib/**/*.rb"].each do |p|
      File.read(p).should_not include "MiniTest"
    end
  end

  describe "before/after/around" do
    it "works" do
      out = run_cmd("ruby spec/cases/hook_all.rb")
      out.should include "Running:\n\nALL\nT1\n.T2\n.ALL-SUB\nTS1\n.TS2\n.\n\nFinished"
    end

    it "fails when using unsupported type" do
      with_env HOOK_TYPE: "foo" do
        out = run_cmd("ruby spec/cases/hook_all.rb", fail: true)
        out.should include "only :each and :all are supported (ArgumentError)"
      end
    end

    it "informs user about missing after :all" do
      with_env HOOK_METHOD: "after" do
        out = run_cmd("ruby spec/cases/hook_all.rb --seed 123", fail: true)
        out.should include ":all is not supported in after (ArgumentError)"
      end
    end

    it "supports around" do
      run_cmd("ruby spec/cases/around.rb").should include "\n2 runs, 3 assertions"
    end

    it "informs user about missing around :all" do
      with_env HOOK_TYPE: "all" do
        out = run_cmd("ruby spec/cases/around.rb", fail: true)
        out.should include "only :each or no argument is supported (ArgumentError)"
      end
    end
  end

  describe "color" do
    it "is color-less without tty" do
      run_cmd("ruby spec/cases/plain.rb").should include "\n2 runs, 2 assertions"
    end

    it "is colorful on tty" do
      simulate_tty do
        run_cmd("ruby spec/cases/plain.rb").should include "\n\e[32m2 runs, 2 assertions"
      end
    end

    it "is colorful without tty but --rg" do
      run_cmd("ruby spec/cases/plain.rb --rg").should include "\n\e[32m2 runs, 2 assertions"
    end

    it "is color-less with --no-rg and tty" do
      simulate_tty do
        run_cmd("ruby spec/cases/plain.rb --no-rg").should include "\n2 runs, 2 assertions"
      end
    end
  end

  describe "timeout" do
    it "times out long running tests" do
      result = run_cmd("ruby spec/cases/timeout.rb -v", fail: true)

      # 1 test takes too long and fails with a nice error message
      result.should include "Maxitest::Timeout::TestCaseTimeout: Test took too long to finish, aborting"

      # results look normal
      result.should include ", 2 errors,"
    end

    it "times out after custom interval" do
      result = run_cmd("CUSTOM=1 ruby spec/cases/timeout.rb -v", fail: true)

      # 1 test takes too long and fails with a nice error message
      result.should include "Maxitest::Timeout::TestCaseTimeout: Test took too long to finish, aborting"

      # results look normal
      result.should include ", 2 errors,"
    end

    it "does not time out when disabled" do
      result = run_cmd("DISABLE=1 ruby spec/cases/timeout.rb -v")

      # 1 test takes too long and fails with a nice error message
      result.should include "DID NOT TIME OUT"

      # results look normal
      result.should include "4 runs"
    end
  end

  describe "global_must" do
    let(:deprecated) { "DEPRECATED" }

    it "complain when not used" do
      run_cmd("ruby spec/cases/plain.rb").should include deprecated
    end

    it "does not complain when used" do
      with_global_must do
        run_cmd("ruby spec/cases/plain.rb").should_not include deprecated
      end
    end

    it "fails when used in threads" do
        with_global_must do
          run_cmd("ruby spec/cases/global_must.rb")
        end
      end
  end

  describe "extra threads" do
    it "fails on extra and passes on regular" do
      result = with_global_must do
        run_cmd("ruby spec/cases/threads.rb -v", fail: true)
      end
      result.gsub(/\d\.\d+/, "0.0").should include <<-OUT.gsub(/^\s+/, "")
        threads#test_0001_is fine without extra threads = 0.0 s = .
        threads#test_0002_fails on extra threads = 0.0 s = F
        threads#test_0003_can kill extra threads = 0.0 s = .
        threads#test_0004_can wait for extra threads = 0.0 s = .
      OUT
    end
  end

  describe "line" do
    let(:focus) { "Focus on failing tests:" }
    let(:expected_command) { "mtest spec/cases/line.rb:8" }

    it "prints line numbers on failed" do
      run_cmd("ruby spec/cases/line.rb", fail: true).should include "#{focus}\n#{expected_command}"
    end

    it "can run with line numbers" do
      result = run_cmd(expected_command, fail: true)
      result.should include("1 runs, 1 assertions, 1 failures, 0 errors, 0 skips")
      result.should_not include(focus) # ran 1 line, no need to reprint
    end

    it "can describe with line numbers" do
      result = run_cmd("mtest spec/cases/line.rb:12")
      result.should include("2 runs, 2 assertions, 0 failures, 0 errors, 0 skips")
    end

    it "can run with -l line numbers" do
      result = run_cmd("ruby spec/cases/line.rb -l 8", fail: true)
      result.should include("1 runs, 1 assertions, 1 failures, 0 errors, 0 skips")
      result.should_not include(focus) # ran 1 line, no need to reprint
    end

    it "uses colors on tty" do
      simulate_tty do
        run_cmd("ruby spec/cases/line.rb", fail: true).should include "\e[31m#{expected_command}\e[0m"
      end
    end
  end

  describe "Interrupts" do
    it "stops on ctrl+c and prints errors" do
      t = Thread.new { run_cmd("ruby spec/cases/cltr_c.rb", fail: true) }
      sleep 1 # let thread start
      kill_process_with_name("spec/cases/cltr_c.rb")
      output = t.value
      output.should include "4 runs, 1 assertions, 1 failures, 1 errors, 2 skips" # failed, error from interrupt (so you see a backtrace), rest skipped
      output.gsub(/:\d+:in/, ":D:in").should include "cltr_c.rb:D:in `sleep'" # let you know where it happened
      output.should include "Interrupt:" # let you know what happened
      output.should include "Expected: true\n  Actual: false" # not hide other errors
      output.scan(/BEFORE/).size.should == 2 # before calls avoided when skipping
      output.scan(/AFTER/).size.should == 2 # after calls avoided when skipping
    end

    it "allows Interrupts to be caught normally" do
      output = run_cmd("ruby spec/cases/catch_interrupt.rb")
      output.should include "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "catches directly raised Interrupt" do
      output = run_cmd("ruby spec/cases/raise_interrupt.rb", fail: true)
      output.should include "runs, "
      output.should include "Interrupt: Interrupt"
    end

    it "shows backtraces when in verbose mode" do
      t = Thread.new { run_cmd("ruby spec/cases/cltr_c.rb -v", fail: true) }
      sleep 1 # let thread start
      kill_process_with_name("spec/cases/cltr_c.rb")
      output = t.value
      output.gsub(/:\d+:in/, ":D:in").should include "cltr_c.rb:D:in `sleep'" # let you know where it happened
    end
  end

  describe "mtest" do
    it "shows version" do
      run_cmd("mtest -v").should == Maxitest::VERSION
      run_cmd("mtest --version").should == Maxitest::VERSION
    end

    it "shows help" do
      run_cmd("mtest -h").should include "Usage:"
      run_cmd("mtest --help").should include "Usage:"
    end

    it "runs a single file" do
      run_cmd("mtest spec/cases/mtest/a_test.rb").should include "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "runs a folder" do
      run_cmd("mtest spec/cases/mtest").should include "2 runs, 2 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "runs multiple files" do
      run_cmd("mtest spec/cases/mtest/a_test.rb spec/cases/mtest/c.rb").should include "2 runs, 2 assertions, 0 failures, 0 errors, 0 skips"
    end
  end

  describe "backtraces" do
    it "shows no backtrace without verbose" do
      result = run_cmd("ruby spec/cases/error_and_failure.rb", fail: true)
      result.should include "error_and_failure.rb:5"
      result.should include "error_and_failure.rb:9"
      result.should_not include "minitest.rb"
    end

    it "shows backtrace for errors with verbose" do
      result = run_cmd("ruby spec/cases/error_and_failure.rb -n '/errors/' -v", fail: true)
      result.should include "1 run"
      result.should include "error_and_failure.rb:5"
      result.should include "minitest.rb"
    end

    it "shows backtrace for failures with verbose" do
      result = run_cmd("ruby spec/cases/error_and_failure.rb -n '/fails/' -v", fail: true)
      result.should include "1 run"
      result.should include "error_and_failure.rb:9"
      result.should include "minitest.rb"
    end
  end

  describe "parallel" do
    it "can run in parallel" do
      result = run_cmd("MT_CPU=3 ruby spec/cases/parallel.rb -v")
      result.should include "\n3 runs"
      result.should include "Finished in 0.1"
    end
  end

  private

  def simulate_tty(&block)
    with_env SIMULATE_TTY: 'true', &block
  end

  def with_global_must(&block)
    with_env GLOBAL_MUST: 'true', &block
  end

  def with_env(h)
    old = ENV.to_h
    h.each { |k, v| ENV[k.to_s] = v}
    yield
  ensure
    ENV.replace old
  end

  def run_cmd(command, options = {})
    stdout, stderr, status = Open3.capture3(command)

    unless options[:keep_output]
      stdout += "\n" + stderr
    end

    raise "#{options[:fail] ? "SUCCESS" : "FAIL"} #{command}\n#{stdout}" if status.success? == !!options[:fail]

    stdout.strip
  end

  # copied from https://github.com/grosser/parallel/blob/master/spec/parallel_spec.rb#L10-L15
  def kill_process_with_name(file, signal='INT')
    running_processes = `ps -f`.split("\n").map{ |line| line.split(/\s+/) }
    pid_index = running_processes.detect { |p| p.include?("UID") }.index("UID") + 1
    parent = running_processes.detect { |p| p.include?(file) and not p.include?("sh") }
    raise "Unable to find parent in #{running_processes} with #{file}" unless parent
    `kill -s #{signal} #{parent.fetch(pid_index)}`
  end
end
