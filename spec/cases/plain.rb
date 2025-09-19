require "./spec/cases/helper"

describe 2 do
  it "is even" do
    (ENV['USE_GLOBAL_MUST'] ? 2.even? : _(2.even?)).must_equal true
  end

  it "is not odd" do
    (ENV['USE_GLOBAL_MUST'] ? 2.odd? : _(2.odd?)).must_equal false
  end
end
