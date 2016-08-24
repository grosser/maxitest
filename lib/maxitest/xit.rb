Minitest::Spec::DSL.class_eval do
  def xit(*args, &block)
    describe "skip" do
      def setup; end
      def teardown; end
      it(*args)
    end
  end
end
