Minitest::BacktraceFilter.send(:prepend, Module.new do
  def filter(*)
    backtrace = super
    pwd = "#{Dir.pwd}/"
    section = pwd.size..-1
    backtrace.map { |b| b.start_with?(pwd) ? b[section] : b }
  end
end)
