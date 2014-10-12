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
end
