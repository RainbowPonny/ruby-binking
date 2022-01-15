# Binking

Simple API client for binking.io service

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binking'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install binking

## Usage

At first you need to setup config:

```ruby
require 'binking'

Binking.configure do |config|
  config.api_token = 'my_api_key'
end
```

If you need caching, you can add `config.cache` parameter with `FaradayMiddleware::Caching` [compatible cache store](https://github.com/lostisland/faraday_middleware/wiki/Caching).

Add `config.logger` if you need logging.

And then you can simply get one of resource binking resource `form`/`bank`/`banks`

```ruby
Binking.form('123456')
Binking.bank('ru-sberasdbank')
Binking.bank('ru-sberasdbank,ru-rosbanqwek')
```

Add `sandbox: true`, if you need sandbox mode. By default it's `false`. You can also setup sandbox mode in config `config.sandbox = true`

```ruby
Binking.form('123456', sandbox: true)
```

Add `fields` param with array of fields to get certain fields.

```ruby
Binking.form('123456', fields: [:bankAlias, :bankLogoBigOriginalPng])
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RainbowPonny/ruby-binking. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/RainbowPonny/ruby-binking/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Binking project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RainbowPonny/ruby-binking/blob/master/CODE_OF_CONDUCT.md).
