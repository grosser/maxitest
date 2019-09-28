# Allow global must_* assertion style without deprecations
#
# Must be required before maxitest/autorun
Module.prepend(Module.new do
  def infect_an_assertion(_, new_name, *)
    super # define with deprecation

    # remove old to avoid warnings from re-defining
    remove_method new_name

    # re-define without deprecation
    class_eval <<-EOM, __FILE__, __LINE__ + 1
      def #{new_name} *args
        Minitest::Expectation.new(self, Minitest::Spec.current).#{new_name}(*args)
      end
    EOM
  end
end)
