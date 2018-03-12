require "./spec/cases/helper"
require "maxitest/threads"

describe "threads" do
  order_dependent!

  def assert_correct_threads
    Thread.list.count.must_equal 3
  end

  def create_thread
    Thread.new { sleep 0.1 }
  end

  it "is fine without extra threads" do
    assert_correct_threads
  end

  it "fails on extra threads" do
    assert_correct_threads
    create_thread
    Thread.list.must_equal 4
  end

  it "can kill extra threads" do
    assert_correct_threads
    create_thread
    maxitest_kill_extra_threads
  end

  it "can wait for extra threads" do
    assert_correct_threads
    maxitest_wait_for_extra_threads
  end
end
