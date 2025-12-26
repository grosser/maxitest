require "./spec/cases/helper"

$ordered_calls = []

describe 2 do
  order_dependent!

  it "a" do
    $ordered_calls << 1
  end

  it "c" do
    $ordered_calls << 2
  end

  it "b" do
    $ordered_calls << 3
  end

  it "d" do
    $ordered_calls << 4
  end

  it "z" do
    _($ordered_calls).must_equal [1, 2, 3, 4]
  end
end
