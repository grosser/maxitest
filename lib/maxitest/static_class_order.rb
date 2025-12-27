# frozen_string_literal: true
module Maxitest
  class << self
    attr_accessor :static_class_order
  end
end

class << Minitest::Runnable
  alias runnables_without_static_order runnables

  def runnables
    return runnables_without_static_order unless Maxitest.static_class_order

    #   Minitest.__run uses Runnable.runnables.shuffle -> hack it
    runnables = runnables_without_static_order
    def runnables.shuffle
      self
    end

    # ugly hack to fight minitest 5.10 https://github.com/seattlerb/minitest/commit/478e3f9cfeb0a2f8cc4b029bbcbe7bb16648dd96
    def runnables.reject(*args, &block)
      reject!(*args, &block)
    end

    runnables
  end
end
