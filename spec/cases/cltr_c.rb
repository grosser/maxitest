require "./spec/cases/helper"

describe 2 do
  i_suck_and_my_tests_are_order_dependent!

  it "is even" do
    false.must_equal true
  end

  it "is not odd" do
    sleep 10
  end

  it "stops after" do
    sleep 10
  end

  it "really does ..." do
    puts ">>>>>>>>#{__FILE__}:#{__LINE__}>>>>>>>>"
    puts caller
    puts "<<<<<<<<#{__FILE__}:#{__LINE__-2}<<<<<<<<"
    sleep 10
  end
end
