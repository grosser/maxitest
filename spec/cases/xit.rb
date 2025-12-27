# frozen_string_literal: true
require "./spec/cases/helper"

describe 2 do
  it 'includes the xit module' do
    assert_includes Minitest::Spec::DSL.included_modules, Maxitest::XitMethod
  end

  xit "is even" do
    _(2.even?).must_equal true
  end

  it "is odd" do
    _(2.odd?).must_equal false
  end

  describe "with evil setup/teardown" do
    before { raise "called before" }
    after { raise "called after" }

    xit "should not be called" do
      raise
    end
  end
end
