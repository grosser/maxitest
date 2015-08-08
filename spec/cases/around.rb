require "./spec/cases/helper"

describe "2" do
  let(:calls) { [] }

  before { calls << 1 }
  before { calls << 2 }
  around { |test| calls << 3; test.call }
  around { |test| calls << 4; test.call }
  after  { calls.must_equal [6, 7, 8, 9, 3, 4, 1, 2, 5] }
  after  { calls << 5 }

  around(:all) { |test| calls << 6; test.call }
  around(:all) { |test| calls << 7; test.call }
  before(:all) { calls << 8 }
  before(:all) { calls << 9 }
  after(:all) { calls << 10 }
  after(:all) { calls << 11 }

  it "is ordered" do
    calls.must_equal [6, 7, 8, 9, 3, 4, 1, 2]
  end
end
