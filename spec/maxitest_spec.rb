require "spec_helper"

describe Maxitest do
  it "has a VERSION" do
    Maxitest::VERSION.should =~ /^[\.\da-z]+$/
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
    sh("ruby spec/cases/around.rb").should include "\n1 runs, 2 assertions"
  end

  it "supports context" do
    sh("ruby spec/cases/context.rb").should include "\n2 runs, 2 assertions"
  end

  it "supports let!" do
    sh("ruby spec/cases/let_bang.rb").should include "\n1 runs, 1 assertions"
  end

  describe "line" do
    let(:focus) { "Focus on failing tests:" }
    let(:expected_command) { "ruby spec/cases/line.rb -l 8" }

    it "prints line numbers on failed" do
      sh("ruby spec/cases/line.rb", fail: true).should include "#{focus}\n#{expected_command}"
    end

    it "can run with line numbers" do
      result = sh(expected_command, fail: true)
      result.should include("1 runs, 1 assertions, 1 failures, 0 errors, 0 skips")
      result.should_not include(focus) # ran 1 line, no need to reprint
    end

    it "uses colors on tty" do
      simulate_tty do
        sh("ruby spec/cases/line.rb", fail: true).should include "\e[31m#{expected_command}\e[0m"
      end
    end
  end

  it "stops on ctrl+c and prints errors" do
    t = Thread.new { sh("ruby spec/cases/cltr_c.rb", fail: true) }
    sleep 2 # let thread start
    kill_process_with_name("spec/cases/cltr_c.rb")
    output = t.value
    output.should include "4 runs, 1 assertions, 1 failures, 1 errors, 2 skips" # failed, error from interrupt (so you see a backtrace), rest skipped
    output.should include "Maxitest::Interrupted: Execution interrupted by user" # let you know what happened
    output.should include "Expected: true\n  Actual: false" # not hide other errors
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
    parent_pid = running_processes.detect { |p| p.include?(file) and not p.include?("sh") }[pid_index]
    `kill -s #{signal} #{parent_pid}`
  end
end
