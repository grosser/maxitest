require 'bundler/setup'
$VERBOSE = true

if ENV['SIMULATE_TTY']
  def $stdout.tty?
    true
  end
end

if ENV['GLOBAL_MUST']
  require 'maxitest/global_must'
end

require 'maxitest/autorun'
