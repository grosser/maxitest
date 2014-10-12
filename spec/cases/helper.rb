require 'bundler/setup'
if ENV['SIMULATE_TTY']
  def $stdout.tty?
    true
  end
end
require 'maxitest/autorun'
