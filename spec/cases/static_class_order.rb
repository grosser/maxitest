require "./spec/cases/helper"
Maxitest.static_class_order = true
$calls = []

5.times do |i|
  describe rand do
    it { puts "#{i}" }

    describe rand do
      it { puts "#{i}n" }
    end
  end
end
