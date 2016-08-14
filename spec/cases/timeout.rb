require "./spec/cases/helper"
require "maxitest/timeout"

Maxitest.timeout = (ENV['DISABLE'] ? false : 0.1)

describe 2 do
  it "x" do
    1
  end

  it "times out" do
    sleep 1
    puts "DID NOT TIME OUT"
  end

  it "y" do
    1
  end
end
