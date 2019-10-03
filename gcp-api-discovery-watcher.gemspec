Gem::Specification.new do |spec|
  spec.name          = "gcp-api-discovery-watcher"
  spec.version       = "0.0.1"
  spec.authors       = ["nagachika"]
  spec.email         = ["nagachika@ruby-lang.org"]

  spec.summary       = %q{I AM ALL SEEING EYES}
  spec.description   = %q{I AM ALL SEEING EYES}
  spec.homepage      = "https://github.com/nagachika/gcp-api-discovery-watcher"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "diffy"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
