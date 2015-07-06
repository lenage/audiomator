# Audiomator

A ffmpeg wrapper for ruby to easy split and processing audio files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audiomator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install audiomator

## Usage

    ## Load an audio file
    @audio_file = "PATH/TO/AUDIO_FILE/FILENAME.m4a"
    @record = Audiomator::Record.new(@audio_file)

    # Get audio metadata
    @record.duration
    @record.bitrate
    @record.size
    @record.sample_rate
    @record.codec

    # any FFMPEG errors when loading audio
    @record.valid?

    # clip audio with start_time and end_time
    @start_time = '00:00:00.59'
    @end_time = '00:00:01.53'
    @record.clip(@start_time, @end_time)

    # Adding metadata to output audio file
    metadata = {description: 'This is AudioMator'}
    @record.clip(@start_time, @end_time, nil, metadata: metadata)

    # Add prefix to save all clips to a specify folder
    @record.clip(@start_time, @end_time, nil, prefix: 'clips')

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/lenage/audiomator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
