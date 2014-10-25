require "./spec/cases/helper"

describe 2 do
  it "is even" do
    2.even?.must_equal true
  end

  it "is not odd" do
    2.odd?.must_equal true
  end

  describe "block" do
    it "is even" do
      2.even?.must_equal true
    end

    it "is still even" do
      2.even?.must_equal true
    end
  end
end
