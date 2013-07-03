# since-when

[![Build Status](https://travis-ci.org/modcloth-labs/since-when.png?branch=master)](https://travis-ci.org/modcloth-labs/since-when)

since-when is a way to manage repeated cron-like jobs in ruby. Rather
than trying to recreate or replace proven scheduling tools, it works
with them.

## Installation

Add this line to your application's Gemfile:

    gem 'since-when', github: 'modcloth-labs/since-when'

then execute:

    $ bundle

## Usage

```ruby
  SinceWhen::MissedRunner.new('/path/to/metafile').run(:day) do |time|
    # run your job with each yielded time
  end
```


* since-when will use the metafile to track when your job ran last, and
calculate the in-between times it should have run since the last run.

* If your job completes successfuly, since-when will update the metafile
based on the last successful run time.

* If your job raise an exception, since-when will handle it by only
updating the metafile to the last successful runtime (or not at all if
all job executions failed).


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
