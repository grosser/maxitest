require "./spec/cases/helper"

describe 2 do
  it "is even" do
    _(2.even?).must_equal true
  end

  it "is not odd" do
    _(2.odd?).must_equal true
  end

  describe "block" do
    it "is even" do
      _(2.even?).must_equal true
    end

    it "is still even" do
      _(2.even?).must_equal true
    end
  end
end
