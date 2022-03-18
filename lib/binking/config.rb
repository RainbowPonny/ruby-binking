# frozen_string_literal: true

module Binking
  class Config
    DEFAULT_HOST = "https://api.binking.io"

    attr_accessor :api_token, :host, :sandbox, :cache, :logger, :request_options

    def initialize(api_token: nil,
                   host: DEFAULT_HOST,
                   sandbox: false,
                   cache: nil,
                   logger: nil,
                   request_options: {})
      @api_token = api_token
      @host = host
      @sandbox = sandbox
      @cache = cache
      @logger = logger
      @request_options = request_options
    end

    def configured?
      [api_token, host].all? { |param| !param.nil? && !param.empty? }
    end
  end
end
