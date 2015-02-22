module Maxitest
  class << self
    attr_accessor :static_class_order
  end
end

class << Minitest::Runnable
  alias_method :runnables_without_static_order, :runnables

  def runnables
    return runnables_without_static_order unless Maxitest.static_class_order
    #   Minitest.__run uses Runnable.runnables.shuffle -> hack it
    runnables = runnables_without_static_order
    def runnables.shuffle
      self
    end
    runnables
  end
end
