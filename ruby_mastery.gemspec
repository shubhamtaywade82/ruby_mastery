# frozen_string_literal: true

require_relative "lib/ruby_mastery/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_mastery"
  spec.version       = RubyMastery::VERSION
  spec.authors       = ["Nemesis"]
  spec.email         = ["nemesis@example.com"]

  spec.summary       = "Static analysis and architectural monitoring for Rails."
  spec.description   = "Enforces Ruby idioms and Rails domain architecture via AST analysis."
  spec.homepage      = "https://github.com/nemesis/ruby_mastery"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}) || f.end_with?(".gem")
    end
  end
  spec.bindir        = "exe"
  spec.executables   = ["ruby_mastery"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parser", "~> 3.0"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "unparser", "~> 0.6"
  spec.add_dependency "terminal-table", "~> 3.0"

  spec.add_development_dependency "rspec", "~> 3.0"
end
