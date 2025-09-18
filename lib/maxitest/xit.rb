# frozen_string_literal: true

module Maxitest
  module XitMethod
    def xit(*args, &_block)
      describe 'skip' do
        define_method(:setup) {}
        define_method(:teardown) {}
        it(*args)
      end
    end

    def self.included(base)
      base.extend(self)
    end
  end
end

Minitest::Spec::DSL.include(Maxitest::XitMethod)
