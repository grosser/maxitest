name = "maxitest"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, Maxitest::VERSION do |s|
  s.summary = "Full featured Minitest without annoying problems."
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.executables = ["mtest"]

  s.add_runtime_dependency "minitest", [">= 5.0.0", "< 5.5.0"]

  s.add_development_dependency "bump"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "wwtd"
end
