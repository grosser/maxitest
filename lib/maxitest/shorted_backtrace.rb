# frozen_string_literal: true
#
# convert absolute paths in backtrace to relative paths
Minitest::BacktraceFilter.prepend(
  Module.new do
    def filter(*)
      backtrace = super
      pwd = "#{Dir.pwd}/"
      section = pwd.size..-1
      backtrace.map { |b| b.start_with?(pwd) ? b[section] : b }
    end
  end
)
