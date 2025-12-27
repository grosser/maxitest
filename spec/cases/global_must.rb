# frozen_string_literal: true
if ENV['GLOBAL_MUST']
  require 'maxitest/global_must'
end

require "./spec/cases/helper"

describe "threads" do
  def assert_it
    1.must_equal 1
  end

  it "can assert normal" do
    assert_it
  end

  it "can assert in threads" do
    result = "not called"
    Thread.new do
      assert_it
    rescue NotImplementedError
      result = "error"
    end.join
    result.must_equal "error"
  end
end
