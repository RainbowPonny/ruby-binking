# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module Binking
  class Client
    attr_accessor :api_token, :host, :sandbox, :cache, :logger, :options

    def initialize(api_token: Binking.config.api_token,
                   host: Binking.config.host,
                   sandbox: Binking.config.sandbox,
                   cache: Binking.config.cache,
                   logger: Binking.config.logger,
                   options: Binking.config.request_options)
      @api_token = api_token
      @host = host
      @sandbox = sandbox
      @cache = cache
      @logger = logger
      @options = options
    end

    def get(path, params = nil)
      connection.get(path.gsub(%r{^/}, ""), params) do |req|
        req.params["apiKey"] = api_token if api_token
        req.params["sandbox"] = 1 if sandbox
      end
    end

    private

    def connection
      @connection ||= Faraday.new(host, request: options) do |builder|
        builder.use(FaradayMiddleware::Caching, cache) if cache
        builder.use Faraday::Response::RaiseError
        builder.request :url_encoded
        builder.response :json
        builder.response(:logger, logger, { headers: true, bodies: true }) if logger
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
