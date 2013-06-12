# -*- encoding: utf-8 -*-
require File.expand_path('../lib/since_when/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Pat Bair']
  gem.email         = %w(p.bair@modcloth.com)
  gem.description   = %q{Finds missed opportunites in cron jobs}
  gem.summary       = %q{Find the times something should have run if it failed to run (successfully)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "since-when"
  gem.require_paths = ["lib"]
  gem.version       = SinceWhen::VERSION
end
