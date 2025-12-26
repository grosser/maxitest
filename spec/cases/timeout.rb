require "./spec/cases/helper"
require "maxitest/timeout"

Maxitest.timeout = (ENV['DISABLE'] || ENV['CUSTOM'] ? false : 0.1)

describe 2 do
  if ENV['CUSTOM']
    let(:maxitest_timeout) { 0.1 }
  end

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

  describe "sum" do
    before { sleep 0.04 }

    after do
      sleep 0.04
      puts "DID NOT TIME OUT"
    end

    it "fails" do
      sleep 0.04
    end
  end
end
