ENV["MT_CPU"] = "3" # make this test hardware independent, need N for old minitest versions
require "./spec/cases/helper"

describe String do
  parallelize_me!

  it "1" do
    sleep 0.1
  end

  it "2" do
    sleep 0.1
  end

  it "3" do
    sleep 0.1
  end
end
