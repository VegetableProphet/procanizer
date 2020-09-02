# Procanizer

Convenient proc generator for chaining.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'procanizer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install procanizer

## Usage

```ruby
# CHAINING EXAMPLE

module SomeMethods
  def increment(arr)
    arr.map { |i| i + 1 }
  end

  def stringify(arr)
    arr.map { |i| i.to_s }
  end

  def capitalize(arr)
    arr.map { |i| i.capitalize }
  end
end


class SuperService
  extend Procanizer
  include SomeMethods

  add_proc_for :increment, :stringify, :capitalize

  def initialize
    @final = []
  end

  def call
    [[1, 2], [3, 4], [5, 6]].each(
      &increment_proc >> stringify_proc >> capitalize_proc >> commit_proc
    )

    puts @final.join(":")
  end

  with_proc def commit(arr)
    @final += arr.map { |i| "#{i} commited!" }
  end
end
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/VegetableProphet/procanizer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
