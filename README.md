# Ruby Context

This gem allows you to define and override global values inspired in [Reactjs Context api](https://reactjs.org/docs/context.html)

You can use this gem in any ruby project, including Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-context'
```

And then execute:

    $ bundle

## Usage in Rails

imagine you want to override rails logger

Create a config/initializers/app_logger.rb

```ruby
# Default value isn't necessary, but good

APP_LOGGER = Context::Context.new(default_value: Rails.logger)
```

Image you have a worker called send_mail_worker.rb and you want that every call to Rails.logger should be override to a different log.

```ruby
class SendMailWorker
    def do_work
       email_logger = Logger.new
       APP_LOGGER.with(email_logger) do
           MailService.run!
       end
    end
end
```

So now every calls of APP_LOGGER will not call Rails.logger anymore, but email_logger!

```ruby
class MailService
    def self.run!
       APP_LOGGER.info "runing mail service"
       OtherClass.execute!
    end
end
```

```ruby
class OtherClass
    def self.execute!
       APP_LOGGER.info "executing"
    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/context. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Context project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/context/blob/master/CODE_OF_CONDUCT.md).
