# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "soundcloud/embed_tag/version"

Gem::Specification.new do |s|
  s.name        = "soundcloud-embed_tag"
  s.version     = Soundcloud::EmbedTag::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonathan Davies | JonnieCache"]
  s.email       = ["jonnie@cleverna.me"]
  s.homepage    = "http://rubygems.org/gems/soundcloud-embed_tag"
  s.summary     = %q{Automatically replace bbcode style tags with soundcloud embeds}
  s.description = %q{Automatically replace bbcode style tags with soundcloud embeds}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.add_dependency 'httparty', '~> 0'
  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'simplecov', '~> 0'
end
