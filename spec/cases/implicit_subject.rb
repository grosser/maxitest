require "./spec/cases/helper"
require "maxitest/implicit_subject"

class DoNotCallMe
  def initialize
    raise "WRONG"
  end
end

describe String do
  it "has implicit subject" do
    _(subject).must_equal ""
  end

  describe Array do
    def other_method
      true
    end

    it "has nested implicit subject" do
      _(subject).must_equal []
      _(other_method).must_equal true
    end
  end

  describe Hash do
    it "has other nested implicit subject" do
      _(subject).must_equal({})
    end

    describe "strings" do
      it "does not overwrite subject" do
        _(subject).must_equal({})
      end
    end

    describe :symbols do
      it "does not overwrite subject" do
        _(subject).must_equal({})
      end
    end
  end

  describe DoNotCallMe do
    let(:subject) { 1 }

    it "can overwrite" do
      subject.must_equal 1
    end
  end
end

describe "without" do
  it "raises as expected" do
    assert_raises(NameError) { subject }
  end
end
