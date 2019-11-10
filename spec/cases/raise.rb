require "./spec/cases/helper"

# cause a raise in a required file
module Maxitest
  class Timeout
  end
end

describe "explode" do
  it "explodes" do
    require 'maxitest/timeout'
  end
end
