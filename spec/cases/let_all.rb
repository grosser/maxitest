require "./spec/cases/helper"

# executing sub-classes first makes the tests fail
Maxitest.static_class_order = true

describe "A" do
  order_dependent!

  let(:calls) { [] }
  let_all(:foo) { calls << 1; nil }

  describe "subclass gets randomly executed first" do
    it "is called when used" do
      _(calls).must_equal []
      _(foo).must_be_nil
      _(calls).must_equal [1]
    end
  end

  describe "then another subclass" do
    it "is not called multiple times" do
      _(calls).must_equal []
      _(foo).must_be_nil
      _(calls).must_equal []
    end
  end

  describe "overwrite" do
    let_all(:foo) { calls << 2; true }

    it "can overwrite" do
      _(calls).must_equal []
      _(foo).must_equal true
      _(calls).must_equal [2]
    end
  end

  describe "nested" do
    it "is not called multiple times from child classes" do
      _(calls).must_equal []
      _(foo).must_be_nil
      _(calls).must_equal []
    end
  end
end

describe "B" do
  let_all(:foo) { :foo }

  it "does not go across class boundaries" do
    _(foo).must_equal :foo
  end
end

