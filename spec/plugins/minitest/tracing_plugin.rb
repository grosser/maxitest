module Minitest
  def self.plugin_tracing_init(options)
    puts "Initializing tracing plugin ...\n"
  end

  def self.plugin_tracing_options(opts, options)
    puts "Processing options ... \n"
  end
end