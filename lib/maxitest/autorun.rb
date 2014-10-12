require "minitest"

if $stdout.tty?
  require "maxitest/vendor/rg"
  Minitest.extensions << "rg"
  Minitest::RG.rg!
end

require "maxitest/vendor/line"
Minitest.extensions << "line"

require "minitest/autorun"
require "maxitest/vendor/around"

Minitest::Spec::DSL.class_eval do
  alias_method :context, :describe

  def let!(name, &block)
    let(name, &block)
    before { send(name) }
  end
end
