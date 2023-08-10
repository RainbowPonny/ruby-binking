# frozen_string_literal: true

require_relative "binking/version"
require "binking/config"
require "binking/client"
require "binking/fields"
require "binking/request_resource"

module Binking
  class NotConfiguredError < StandardError; end
  extend self

  def configure
    @config ||= Config.new
    yield @config if block_given?
    @config
  end
  alias_method :config, :configure

  def configured?
    config.configured?
  end

  %i[form bank banks].each do |resource_name|
    define_singleton_method(resource_name) do |*args| 
      raise NotConfiguredError unless configured?

      RequestResource.get(resource_name, *args)
    end
  end
end
