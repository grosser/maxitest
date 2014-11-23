# this is a bit hacky / overwrites describe, so not included by default ...
module Maxitest
  module ImplicitSubject
    def describe(*args, &block)
      klass = super
      klass.let(:subject) { args.first.new } if args.first.is_a?(Class)
      klass
    end
  end
end

Object.send(:include, Maxitest::ImplicitSubject) # Minitest hacks Kernel -> we need to use alias method or go into Object
