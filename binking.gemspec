# frozen_string_literal: true

require_relative "lib/binking/version"

Gem::Specification.new do |spec|
  spec.name = "binking"
  spec.version = Binking::VERSION
  spec.authors = ["Anton Kostyuk"]
  spec.email = ["anton.kostuk.2012@gmail.com"]

  spec.summary = "Ruby client for binking.io API"
  spec.homepage = "https://github.com/RainbowPonny/ruby-binking"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"
  spec.metadata = { "rubygems_mfa_required" => "true" }

  spec.files = Dir["lib/**/*"]

  spec.add_development_dependency "rspec", "~> 3.2"

  spec.add_dependency "faraday", "~> 1.7.1"
  spec.metadata["rubygems_mfa_required"] = "true"
end
