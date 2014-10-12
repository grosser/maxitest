require "./spec/cases/helper"

describe 2 do
  let(:calls) { [] }
  let!(:foo) { calls << 1 }

  before { calls << 2 }

  it "is called before" do
    calls.must_equal [1, 2]
  end
end
