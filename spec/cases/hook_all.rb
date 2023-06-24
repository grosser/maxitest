require "./spec/cases/helper"

hook_method = (ENV["HOOK_METHOD"] || "before").to_sym
hook_type = (ENV["HOOK_TYPE"] || "all").to_sym

# need this globally or classes don't sort
r = Minitest::Runnable.runnables
def r.shuffle
  self
end

# needed or minitest <=5.15
def r.reject
  replace super
end

describe 2 do
  order_dependent!

  send hook_method, hook_type do
    puts "ALL"
  end

  it "works" do
    puts "T1"
  end

  describe "subclass" do
    order_dependent!

    send hook_method, hook_type do
      puts "ALL-SUB"
    end

    it "still works" do
      puts "TS1"
    end

    it "yes it does" do
      puts "TS2"
    end
  end

  it "works after subclass" do
    puts "T2"
  end
end
