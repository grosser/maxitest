# this is a bit hacky / overwrites describe, so not included by default ...
module Maxitest
  module ImplicitSubject
    def describe(*args, &block)
      super(*args) do
        let(:subject) { args.first.new } if args.first.is_a?(Class)
        instance_exec(&block)
      end
    end
  end
end

Object.include Maxitest::ImplicitSubject # Minitest hacks Kernel -> we need to use alias method or go into Object
