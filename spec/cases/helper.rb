# frozen_string_literal: true
require 'bundler/setup'
$VERBOSE = true

if ENV['SIMULATE_TTY']
  def $stdout.tty?
    true
  end
end

require 'maxitest/autorun'
