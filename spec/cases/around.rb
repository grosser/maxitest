require "./spec/cases/helper"

describe "2" do
  let(:calls) { [] }

  before { calls << 1 }
  around((ENV["HOOK_TYPE"] || "each").to_sym) { |test| calls << 2; test.call }
  around { |test| calls << 3; test.call }
  after  { _(calls).must_equal [1, 2, 3, 4] }
  after  { calls << 4 }

  it "is ordered" do
    _(calls).must_equal [1, 2, 3]
  end
end

class AroundTest < Minitest::Test
  def around
    yield
  end

  def test_things
    assert 1
  end
end
