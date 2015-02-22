Minitest::Spec::DSL.class_eval do
  def let_all(name, &block)
    cache = []
    define_method(name) do
      if cache.empty?
        cache[0] = instance_eval(&block)
      else
        cache[0]
      end
    end
  end
end
