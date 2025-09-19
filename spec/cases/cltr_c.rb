ENV["GLOBAL_MUST"] = "true"
require "./spec/cases/helper"

describe 2 do
  i_suck_and_my_tests_are_order_dependent!

  before { puts "BEFORE" }
  after { puts "AFTER" }

  it "is even" do
    _(false).must_equal true
  end

  it "is not odd" do
    puts "hit Cltr+c"
    sleep 10
  end

  it "stops after" do
    puts "should not get here ..."
    sleep 10
  end

  it "really does ..." do
    puts "should not get here ..."
    sleep 10
  end
end
