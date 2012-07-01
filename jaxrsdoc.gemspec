$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require 'jaxrsdoc_version'

Gem::Specification.new do |s|
  s.name = "jaxrsdoc"
  s.version = JaxrsDoc::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Simon Caplette"]
  s.summary = %q{Website bootstrap style generator for your JAXRS REST API doc}

  s.rubyforge_project = "jaxrsdoc"
  s.files = ["lib/annotations.rb", "lib/parse.rb", "lib/site.rb", "lib/templates.rb", "site/bootstrap.css", "site/jaxrsdoc.css"]
  s.executables = ["bin/jaxrsdoc"]
end