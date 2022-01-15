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

  def method_missing(method_name, *args, &block)
    if %i[form bank banks].include?(method_name)
      raise NotConfiguredError unless configured?

      RequestResource.get(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    connection.respond_to?(method_name) || super
  end
end
