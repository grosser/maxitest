name = "maxitest"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, Maxitest::VERSION do |s|
  s.summary = "Minitest + all the features you always wanted"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE Readme.md`.split("\n")
  s.license = "MIT"
  s.executables = ["mtest"]

  s.add_runtime_dependency "minitest", [">= 5.0.0", "< 5.17.0"]
  s.required_ruby_version = '>= 2.6.0', '< 4' # mirroring minitest

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
