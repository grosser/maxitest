name = "maxitest"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, Maxitest::VERSION do |s|
  s.summary = "Full featured Minitest"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.add_runtime_dependency "minitest", "~> 5.4.2"
  s.executables = ["mtest"]
end
