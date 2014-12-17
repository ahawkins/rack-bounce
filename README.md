# Rack::Bounce

Bounce incoming requests according to a block. Useful for incoming
traffic going to incorrect URLs or other undesireable cases.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-bounce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-bounce

## Usage

    # Use library default bounce checks (currently masscan only)
    use Rack::Bounce

    # Provide a block to check a request. Block recieves a Rack::Request
    # Defaults are NOT applied when block is provided
    use Rack::Bounce do |request|
        request.path =~ /favicon/
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-bounce/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
