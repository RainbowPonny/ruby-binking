class CacheMiddalware < Faraday::Middleware
  DEFAULT_CONDITIONS = ->(env) { env.method == :get || env.method == :head }
  DEFAULT_CACHE_KEY = ->(env) { env.url }

  def initialize(app, store, *args)
    super(app)
    options = args.first || {}

    @store         = store
    @conditions    = options.fetch(:conditions, DEFAULT_CONDITIONS)
    @expires_in    = options.fetch(:expires_in, 30)
    @logger        = options.fetch(:logger, nil)
    @cache_key     = options.fetch(:cache_key, DEFAULT_CACHE_KEY)
  end

  def call(env)
    dup.call!(env)
  end

  protected

  def call!(env)
    response_env = cached_response(env)

    if response_env
      response_env.response_headers['x-faraday-manual-cache'] = 'HIT'
      to_response(response_env)
    else
      @app.call(env).on_complete do |response_env|
        response_env.response_headers['x-faraday-manual-cache'] = 'MISS'
        cache_response(response_env)
      end
    end
  end

  def cache_response(env)
    return unless cacheable?(env) && !env.request_headers['x-faraday-manual-cache']

    info "Cache WRITE: #{key(env)}"
    @store.write(
      key(env),
      env,
      expires_in: expires_in(env)
    )
  end

  def cacheable?(env)
    @conditions.call(env)
  end

  def cached_response(env)
    if cacheable?(env) && !env.request_headers['x-faraday-manual-cache']
      response_env = @store.fetch(key(env))
    end

    if response_env
      info "Cache HIT: #{key(env)}"
    else
      info "Cache MISS: #{key(env)}"
    end

    response_env
  end

  def info(message)
    @logger.info(message) unless @logger.nil?
  end

  def key(env)
    @cache_key.call(env)
  end

  def expires_in(env)
    @expires_in.respond_to?(:call) ? @expires_in.call(env) : @expires_in
  end

  def to_response(env)
    env = env.dup
    env.response_headers['x-faraday-manual-cache'] = 'HIT'
    response = Faraday::Response.new
    response.finish(env) unless env.parallel?
    env.response = response
  end
end
