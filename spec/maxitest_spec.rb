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
