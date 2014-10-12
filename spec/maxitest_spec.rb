require "spec_helper"

describe Maxitest do
  it "has a VERSION" do
    Maxitest::VERSION.should =~ /^[\.\da-z]+$/
  end
end
