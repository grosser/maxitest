Minitest::Spec::DSL.class_eval do
  def let!(name, &block)
    let(name, &block)
    before { send(name) }
  end
end
