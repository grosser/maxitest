require_relative "lib/maxitest/version"

Gem::Specification.new "maxitest", Maxitest::VERSION do |s|
  s.summary = "Minitest + all the features you always wanted"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/maxitest"
  s.files = Dir["{bin,lib}/**/*", "MIT-LICENSE", "README.md", "CHANGELOG.md"]
  s.license = "MIT"
  s.executables = ["mtest"]

  # keep in sync with .github/workflows/actions.yml
  s.add_runtime_dependency "minitest", [">= 5.20.0", "< 6.1.0"]
  s.required_ruby_version = '>= 3.2', '< 3.5'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
