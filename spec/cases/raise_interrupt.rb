# frozen_string_literal: true
require "./spec/cases/helper"

describe 2 do
  i_suck_and_my_tests_are_order_dependent!

  it "xx" do
    raise Interrupt
  end

  it "yyy" do
    assert false
  end
end
