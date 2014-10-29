require "./spec/cases/helper"

describe 2 do
  it "xx" do
    x = 2
    begin
      raise Interrupt
    rescue Interrupt
      x = 1
    else
      x = 3
    end
    x.must_equal 1
  end
end
