# frozen_string_literal: true
require "./spec/cases/helper"

describe 2 do
  it "is even" do
    _(2.even?).must_equal true
  end
end
