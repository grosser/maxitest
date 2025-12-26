# https://raw.githubusercontent.com/judofyr/minitest-line/master/MIT-LICENSE.txt
=begin
Copyright (c) 2014 Magnus Holm

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

# https://raw.githubusercontent.com/judofyr/minitest-line/master/lib/minitest/line_plugin.rb
module Maxitest
  module Line
    module MinitestPlugin
      def self.minitest_plugin_init(options)
        return if options[:include] # do not re-print when already filtered
        Minitest.reporter.reporters << LineReporter.new
      end
    end

    class LineReporter < Minitest::Reporter
      def initialize(*)
        super
        @failures = []
      end

      def record(result)
        if !result.skipped? && !result.passed?
          @failures << result
        end
      end

      def report
        return unless @failures.any?
        io.puts
        io.puts "Focus on failing tests:"
        pwd = Pathname.new(Dir.pwd)
        bin_rails = File.exist?("bin/rails")
        @failures.each do |res|
          result = (res.respond_to?(:source_location) ? res : res.method(res.name))
          file, line = result.source_location
          next unless file

          file = Pathname.new(file)
          file = file.relative_path_from(pwd) if file.absolute?
          output = "#{bin_rails ? "bin/rails test" : "minitest"} #{file}:#{line}"
          output = "\e[31m#{output}\e[0m" if $stdout.tty?
          io.puts output
        end
      end
    end
  end
end
