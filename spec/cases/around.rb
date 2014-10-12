require "./spec/cases/helper"

describe "2" do
  let(:calls) { [] }

  before { calls << 1 }
  around { |test| calls << 2; test.call }
  around { |test| calls << 3; test.call }
  after  { calls.must_equal [1,2,3,4] }
  after  { calls << 4 }

  it "is ordered" do
    calls.must_equal [1,2,3]
  end
end
