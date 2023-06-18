module Maxitest
  class << self
    attr_accessor :hook_all_counter
  end
end
Maxitest.hook_all_counter = 0

module Maxitest
  module HookAll
    [:before, :after].each do |hook|
      # minitest discards the type argument, so we are not sending it along
      define_method(hook) do |type = :each, &block|
        case type
        when :each then super(&block)
        when :all
          raise ArgumentError, ":all is not supported in after" if hook == :after
          c = (Maxitest.hook_all_counter += 1)
          callback = :"maxitest_hook_all_#{c}"
          let_all(callback, &block)
          super() { send callback }
        else
          raise ArgumentError, "only :each and :all are supported"
        end
      end
    end
  end
end

Minitest::Spec::DSL.prepend(Maxitest::HookAll)
