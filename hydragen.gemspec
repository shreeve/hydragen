# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "hydragen"
  s.version     = "0.5.0"
  s.author      = "Steve Shreeve"
  s.email       = "steve.shreeve@gmail.com"
  s.summary     = "Spawn multiple processes to perform simulataneous jobs"
  s.description = "This gem divides work and conquers."
  s.homepage    = "https://github.com/shreeve/hydragen"
  s.license     = "MIT"
  s.files       = `git ls-files`.split("\n") - %w[.gitignore]
end
