require "./spec/cases/helper"

describe 1 do
  it "is even" do
    _(2.even?).must_equal true
  end
end
