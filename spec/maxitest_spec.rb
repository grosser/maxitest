require "spec_helper"

describe Maxitest do
  it "has a VERSION" do
    Maxitest::VERSION.should =~ /^[\.\da-z]+$/
  end

  it "does not add extra output" do
    result = sh("ruby spec/cases/plain.rb")
    result.sub!(/seed \d+/, 'seed X')
    result.gsub!(/\d+\.\d+/, 'X')
    result.should == "Run options: --seed X\n\n# Running:\n\n..\n\nFinished in Xs, X runs/s, X assertions/s.\n\n2 runs, 2 assertions, 0 failures, 0 errors, 0 skips\n"
  end

  it "runs via ruby" do
    sh("ruby spec/cases/plain.rb").should include "\n2 runs, 2 assertions"
  end

  it "is colorful on tty" do
    simulate_tty do
      sh("ruby spec/cases/plain.rb SIMULATE_TTY=1").should include "\e[32m2 runs, 2 assertions"
    end
  end

  it "supports around" do
    sh("ruby spec/cases/around.rb").should include "\n2 runs, 3 assertions"
  end

  it "supports context" do
    sh("ruby spec/cases/context.rb").should include "\n2 runs, 2 assertions"
  end

  it "supports let!" do
    sh("ruby spec/cases/let_bang.rb").should include "\n1 runs, 1 assertions"
  end

  it "supports let_all" do
    sh("ruby spec/cases/let_all.rb")
  end

  it "can use static_class_order" do
    sh("ruby spec/cases/static_class_order.rb").should include("\n0\n.0n\n.1\n.1n\n.2\n.2n\n.3\n.3n\n.4\n.4n\n.\n")
  end

  it "supports order_dependent" do
    sh("ruby spec/cases/order_dependent.rb").should include "5 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
  end

  it "has pending" do
    result = sh("ruby spec/cases/pending.rb -v", :fail => true)
    result.should include "ArgumentError: Need a block to execute" # fails without block
    result.should include "RuntimeError: Fixed" # shows fixed when pending failed
    result.should include "Skipped, no message given" # skip without message
    result.should include "Skipping with a reason" # skip with message
    result.should include "6 runs, 4 assertions, 0 failures, 2 errors, 3 skips"
  end

  it "does not call xit specs" do
    result = sh("ruby spec/cases/xit.rb -v")
    result.should include "(no tests defined)"
    result.should include "3 runs, 1 assertions, 0 failures, 0 errors, 2 skips"
  end

  describe "timeout" do
    it "times out long running tests" do
      result = sh("ruby spec/cases/timeout.rb -v", fail: true)

      # 1 test takes too long and fails with a nice error message
      result.should include "Maxitest::Timeout::TestCaseTimeout: Test took too long to finish, aborting"

      # results look normal
      result.should include ", 1 errors,"
    end

    it "times out after custom interval" do
      result = sh("CUSTOM=1 ruby spec/cases/timeout.rb -v", fail: true)

      # 1 test takes too long and fails with a nice error message
      result.should include "Maxitest::Timeout::TestCaseTimeout: Test took too long to finish, aborting"

      # results look normal
      result.should include ", 1 errors,"
    end

    it "does not time out when disabled" do
      result = sh("DISABLE=1 ruby spec/cases/timeout.rb -v")

      # 1 test takes too long and fails with a nice error message
      result.should include "DID NOT TIME OUT"

      # results look normal
      result.should include "3 runs"
    end
  end

  describe "line" do
    let(:focus) { "Focus on failing tests:" }
    let(:expected_command) { "mtest spec/cases/line.rb:8" }

    it "prints line numbers on failed" do
      sh("ruby spec/cases/line.rb", fail: true).should include "#{focus}\n#{expected_command}"
    end

    it "can run with line numbers" do
      result = sh(expected_command, fail: true)
      result.should include("1 runs, 1 assertions, 1 failures, 0 errors, 0 skips")
      result.should_not include(focus) # ran 1 line, no need to reprint
    end

    it "can describe with line numbers" do
      result = sh("mtest spec/cases/line.rb:12")
      result.should include("2 runs, 2 assertions, 0 failures, 0 errors, 0 skips")
    end

    it "can run with -l line numbers" do
      result = sh("ruby spec/cases/line.rb -l 8", fail: true)
      result.should include("1 runs, 1 assertions, 1 failures, 0 errors, 0 skips")
      result.should_not include(focus) # ran 1 line, no need to reprint
    end

    it "uses colors on tty" do
      simulate_tty do
        sh("ruby spec/cases/line.rb", fail: true).should include "\e[31m#{expected_command}\e[0m"
      end
    end
  end

  describe "Interrupts" do
    it "stops on ctrl+c and prints errors" do
      t = Thread.new { sh("ruby spec/cases/cltr_c.rb", fail: true) }
      sleep 2 # let thread start
      kill_process_with_name("spec/cases/cltr_c.rb")
      output = t.value
      output.should include "4 runs, 1 assertions, 1 failures, 1 errors, 2 skips" # failed, error from interrupt (so you see a backtrace), rest skipped
      output.should include "Interrupt:" # let you know what happened
      output.should include "Expected: true\n  Actual: false" # not hide other errors
    end

    it "allows Interrupts to be catched normally" do
      output = sh("ruby spec/cases/catch_interrupt.rb")
      output.should include "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "catches directly raised Interrupt" do
      output = sh("ruby spec/cases/raise_interrupt.rb", fail: true)
      output.should include "runs, "
      output.should include "Interrupt: Interrupt"
    end
  end

  describe "mtest" do
    it "runs a single file" do
      sh("mtest spec/cases/mtest/a_test.rb").should include "1 runs, 1 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "runs a folder" do
      sh("mtest spec/cases/mtest").should include "2 runs, 2 assertions, 0 failures, 0 errors, 0 skips"
    end

    it "runs multiple files" do
      sh("mtest spec/cases/mtest/a_test.rb spec/cases/mtest/c.rb").should include "2 runs, 2 assertions, 0 failures, 0 errors, 0 skips"
    end
  end

  describe "backtraces" do
    it "shows no backtrace without verbose" do
      result = sh("ruby spec/cases/error_and_failure.rb", fail: true)
      result.should include "error_and_failure.rb:5"
      result.should include "error_and_failure.rb:9"
      result.should_not include "minitest.rb"
    end

    it "shows backtrace for errors with verbose" do
      result = sh("ruby spec/cases/error_and_failure.rb -n '/errors/' -v", fail: true)
      result.should include "1 run"
      result.should include "error_and_failure.rb:5"
      result.should include "minitest.rb"
    end

    it "shows backtrace for failures with verbose" do
      result = sh("ruby spec/cases/error_and_failure.rb -n '/fails/' -v", fail: true)
      result.should include "1 run"
      result.should include "error_and_failure.rb:9"
      result.should include "minitest.rb"
    end
  end

  private

  def simulate_tty
    old, ENV['SIMULATE_TTY'] = ENV['SIMULATE_TTY'], 'true'
    yield
  ensure
    ENV['SIMULATE_TTY'] = old
  end

  def sh(command, options={})
    result = `#{command} #{"2>&1" unless options[:keep_output]}`
    raise "#{options[:fail] ? "SUCCESS" : "FAIL"} #{command}\n#{result}" if $?.success? == !!options[:fail]
    result
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
