require "./spec/cases/helper"

describe 2 do
  context "methods" do
    it "is even" do
      _(2.even?).must_equal true
    end

    it "is not odd" do
      _(2.odd?).must_equal false
    end
  end
end
