# frozen_string_literal: true
module Maxitest
  module LetAll
    def let_all(name, &block)
      cache = []
      define_method(name) do
        if cache.empty?
          cache << instance_eval(&block)
        end
        cache.first
      end
    end

    def self.included(base)
      base.extend(self)
    end
  end
end

Minitest::Spec::DSL.include(Maxitest::LetAll)
