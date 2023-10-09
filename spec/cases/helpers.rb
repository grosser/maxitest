require "./spec/cases/helper"

describe "helpers" do
  describe "#with_env" do
    it "changes env" do
      with_env A: "b" do
        _(ENV["A"]).must_equal "b"
      end
    end

    it "restores env" do
      ENV["A"] = "c"
      with_env A: "b" do
        ENV["B"] = "a"
        _(ENV["A"]).must_equal "b"
      end
      _(ENV["A"]).must_equal "c"
      _(ENV["B"]).must_be_nil
    end
  end

  describe ".with_env" do
    with_env A: "a"
    it "sets env" do
      _(ENV["A"]).must_equal "a"
    end
  end

  describe "#capture_stdout" do
    it "keeps stdout" do
      _(capture_stdout { puts "X" }).must_equal "X\n"
    end

    it "lets stderr through" do
      out, err = capture_io { capture_stdout { warn "X" } }
      _(out).must_equal ""
      _(err).must_equal "X\n"
    end
  end

  describe "#capture_stderr" do
    it "keeps stderr" do
      _(capture_stderr { warn "X" }).must_equal "X\n"
    end

    it "lets stdout through" do
      out, err = capture_io { capture_stderr { puts "X" } }
      _(out).must_equal "X\n"
      _(err).must_equal ""
    end
  end
end
