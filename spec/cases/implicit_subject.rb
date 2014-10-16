require "./spec/cases/helper"
require "maxitest/implicit_subject"

describe String do
  it "has implicit subject" do
    subject.must_equal ""
  end

  describe Array do
    it "has nested implicit subject" do
      subject.must_equal []
    end
  end

  describe Hash do
    it "has other nested implicit subject" do
      subject.must_equal({})
    end

    describe "strings" do
      it "does not overwrite subject" do
        subject.must_equal({})
      end
    end

    describe :symbols do
      it "does not overwrite subject" do
        subject.must_equal({})
      end
    end
  end
end

describe "without" do
  it "raises as expected" do
    assert_raises(NameError) { subject }
  end
end
