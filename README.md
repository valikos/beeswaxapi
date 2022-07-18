# Beeswaxapi

## Supported Ruby versions

This library officially supports the following Ruby versions:

* MRI `>= 2.7.0`

This gem is a wrapper for Beeswax Buzz API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beeswaxapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beeswaxapi

## Usage

To start work with `Beeswaxapi` you need setup your config.

### Configuration

Available configs:

- auth_strategy: by default `basic`. Can be changed to `cookies`.
- cookie\_file: path to file with cookies. Required for `cookies` auth\_strategy.
- base_uri: uri to beeswax api endpoint. Should be with `rest` path
- user_name: email of user
- password: password of user
- logger: this option enable logging

Example configuration for basic auth authentication:

```ruby
BeeswaxAPI::App.configure do |config|
  config.auth_strategy = 'basic'
  config.base_uri      = 'https://sandbox.api.beeswax.com/rest'
  config.user_name     = 'user@mail.com'
  config.password      = 'password'
end
```

Example configuration for cookies authentication:

```ruby
BeeswaxAPI::App.configure do |config|
  config.auth_strategy = 'cookies'
  config.cookie_file   = '/path/to/cookies-file.txt'
  config.base_uri      = 'https://sandbox.api.beeswax.com/rest'
  config.user_name     = 'user@mail.com'
  config.password      = 'password'
end
```

Example of use:

```ruby
  params = {
    advertiser_id: ENV["BEESWAX_ADVERTISER_ID"].to_i,
    creative_asset_name: file_name.html,
    size_in_bytes: 12001,
    notes: "Created by API",
    active: false
  }
  BeeswaxAPI::Campaign.create(body_params: params)
  # if you need to upload asset you should use `body_file` key
  BeeswaxAPI::HtmlAsset::Upload.create(body_file: {creative_content: @file}, path: create_id) # `path` will be added to url: base_uri/rest/html_asset/upload/<path>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Sources
Beeswax Buzz API: [https://docs.beeswax.com/docs]
(https://docs.beeswax.com/docs/getting-started)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/beeswaxapi.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
