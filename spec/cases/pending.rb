require "./spec/cases/helper"

describe 2 do
  it "runs regular tests" do
    _(2.even?).must_equal true
  end

  it "fails when pending is fixed" do
    e = assert_raises Minitest::Assertion do
      pending "fail" do
        _(2).must_equal 2
      end
    end
    _(e.message).must_include "fixed"
  end

  it "skips when pending still needed" do
    e = assert_raises Minitest::Skip do
      pending "Skipping with reason" do
        _(2).must_equal 3, "This should not fail"
      end
    end
    _(e.message).must_equal "Skipping with reason"
  end

  it "skips exceptions" do
    e = assert_raises Minitest::Skip do
      pending "Skipping with exception" do
        raise "Oh noes"
      end
    end
    _(e.message).must_equal "Skipping with exception"
  end

  it "skips without reason" do
    pending do
      _(2).must_equal 3
    end
  end

  it "fails without block" do
    e = assert_raises(ArgumentError) do
      pending "success"
    end
    _(e.message).must_equal "Need a block to execute"
  end

  it "can disable pending" do
    pending "Not skipping", if: false do
      _(2).must_equal 2
    end
  end

  it "can enable pending" do
    pending "skipping conditionally", if: true do
      raise "Oh noes"
    end
  end

  it "fails when given unknown kwargs" do
    assert_raises(ArgumentError) do
      pending "skipping conditionally", unless: true do
        raise "Oh noes"
      end
    end
  end
end
