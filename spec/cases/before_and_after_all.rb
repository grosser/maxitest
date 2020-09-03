require "./spec/cases/helper"
require "maxitest/before_and_after_all"

describe 2 do
  order_dependent!

  let(:from_let) { "from let" }

  before :all do
    puts "BEFORE ALL A -- #{from_let}"
    @before_all = true
  end

  after :all do
    puts "AFTER ALL A -- #{from_let}"
  end

  before do
    puts "BEFORE A -- #{@before_all}"
  end

  after do
    puts "AFTER A"
  end

  it "a 1" do
    true.must_equal true
  end

  describe "nested" do
    order_dependent!

    before :all do
      puts "BEFORE ALL B -- #{from_let}"
    end

    after :all do
      puts "AFTER ALL B -- #{from_let}"
    end

    before do
      puts "BEFORE B -- #{@before_all}"
    end

    after do
      puts "AFTER B"
    end

    it "b 1" do
      true.must_equal true
    end

    it "b 2" do
      true.must_equal true
    end
  end

  it "a 2" do
    true.must_equal true
  end
end
