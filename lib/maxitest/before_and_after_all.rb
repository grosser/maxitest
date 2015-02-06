module Maxitest
  def self.before_all_ran
    @before_all_ran ||= []
  end
end

Minitest::Spec::DSL.class_eval do
  alias_method :before_without_all, :before

  def before(*args, &block)
    if args.first == :all
      id = rand(99999999999999)
      before_without_all(*args[1..-1]) do
        ran = Maxitest.before_all_ran
        unless ran.include?(id)
          ran << id
          instance_exec(&block)
        end
      end
    else
      before_without_all(*args, &block)
    end
  end

  alias_method :after_without_all, :after

  def after(*args, &block)
    if args.first == :all
      after_without_all(*args[1..-1]) do
        c = self.class
        runnable_methods_count = if c.class_variable_defined?(:@@runnable_methods)
          c.class_variable_get(:@@runnable_methods)
        else
          c.class_variable_set(:@@runnable_methods, c.runnable_methods.size)
        end

        current = c.instance_variable_get(:@after_ran_count) || 0
        if current == runnable_methods_count
          instance_exec(&block)
        else
          c.instance_variable_set(:@after_ran_count, current + 1)
        end
      end
    else
      after_without_all(*args, &block)
    end
  end
end
