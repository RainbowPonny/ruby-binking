# frozen_string_literal: true

require "faraday"

module Binking
  class Client
    attr_accessor :api_token, :host, :sandbox, :cache, :logger

    def initialize(api_token: Binking.config.api_token,
                   host: Binking.config.host,
                   sandbox: Binking.config.sandbox,
                   cache: Binking.config.cache,
                   logger: Binking.config.logger)
      @api_token = api_token
      @host = host
      @sandbox = sandbox
      @cache = cache
      @logger = logger
    end

    def get(path, params = nil)
      connection.get(path.gsub(%r{^/}, ""), params) do |req|
        req.params["apiKey"] = api_token if api_token
        req.params["sandbox"] = 1 if sandbox
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: host) do |builder|
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
