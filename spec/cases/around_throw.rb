require "./spec/cases/helper"

describe "2" do
  around { |test| catch(:foo) { test.call } }

  it "can throw" do
    1.must_equal 1
    throw :foo
  end
end
