# https://raw.githubusercontent.com/blowmage/minitest-rg/master/LICENSE
# BEGIN generated by rake update, do not modify
=begin
Copyright (c) 2012 Mike Moore

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
#END generated by rake update, do not modify

# https://raw.githubusercontent.com/blowmage/minitest-rg/master/lib/minitest/rg_plugin.rb
# BEGIN generated by rake update, do not modify
module MiniTest

  def self.plugin_rg_options opts, options # :nodoc:
    opts.on "--rg", "Add red/green to test output." do
      RG.rg!
    end
  end

  def self.plugin_rg_init options # :nodoc:
    if RG.rg?
      io = RG.new options[:io]

      self.reporter.reporters.grep(Minitest::Reporter).each do |rep|
        rep.io = io if rep.io.tty?
      end
    end
  end

  class RG
    VERSION = "5.2.0"

    COLORS = {
      '.' => "\e[32m.\e[0m",
      'E' => "\e[33mE\e[0m",
      'F' => "\e[31mF\e[0m",
      'S' => "\e[36mS\e[0m",
    }

    attr_reader :io, :colors

    def self.rg!
      @rg = true
    end

    def self.rg?
      @rg ||= false
    end

    def initialize io, colors = COLORS
      @io     = io
      @colors = colors
    end

    def print o
      io.print(colors[o] || o)
    end

    def puts o=nil
      return io.puts if o.nil?
      if o =~ /(\d+) failures, (\d+) errors/
        if $1 != '0' || $2 != '0'
          io.puts "\e[31m#{o}\e[0m"
        else
          io.puts "\e[32m#{o}\e[0m"
        end
      else
        io.puts o
      end
    end

    def method_missing msg, *args
      return super unless io.respond_to? msg
      io.send(msg, *args)
    end
  end
end
#END generated by rake update, do not modify