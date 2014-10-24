require "./spec/cases/helper"

describe 2 do
  it "is even" do
    2.even?.must_equal true
  end

  it "is not odd" do
    pending "fail" do
      2.must_equal 2
    end
  end

  it "pends" do
    pending "Skipping with a reason" do
      2.must_equal 3
    end
  end

  it "pends without text" do
    pending do
      2.must_equal 3
    end
  end

  it "fails without block" do
    pending "success"
  end
end
