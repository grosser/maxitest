Minitest::Test.class_eval do
  # lowest block calls the test
  def around
    yield
  end

  # runs around every test with a block, so we hijack it
  alias_method :time_it_without_around, :time_it
  def time_it(*args, &block)
    time_it_without_around(*args) { around(&block) }
  end
end

Minitest::Spec::DSL.class_eval do
  def around(&inside)
    include(Module.new do
      define_method(:around) do |&block|
        super() { instance_exec(block, &inside) }
      end
    end)
  end

  # Minitest does not support multiple before/after blocks
  def before(type=nil, &block)
    include Module.new { define_method(:setup) { super(); instance_exec(&block) } }
  end

  def after(type=nil, &block)
    include Module.new { define_method(:teardown) { instance_exec(&block); super() } }
  end
end
