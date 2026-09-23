# frozen_string_literal: true

require_relative "lib/xamidimura/version"

Gem::Specification.new do |spec|
  spec.name = "xamidimura"
  spec.version = Xamidimura::VERSION
  spec.authors = ["Yudai Takada"]
  spec.email = ["t.yudai92@gmail.com"]
  spec.summary = "Shared source revision primitives for Ruby desktop applications"
  spec.description = "Stable file snapshots and SHA-256 revisions for conflict-safe application saves."
  spec.homepage = "https://github.com/noxdea/xamidimura"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"
  spec.metadata = {
    "source_code_uri" => "#{spec.homepage}/tree/main",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true"
  }
  spec.files = Dir.chdir(__dir__) do
    Dir["{docs,lib,sig,test}/**/*", "README.md", "CHANGELOG.md", "LICENSE.txt"].select { |path| File.file?(path) }
  end
  spec.require_paths = ["lib"]
end
