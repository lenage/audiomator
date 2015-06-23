require 'shellwords'
require 'open3'

module Audiomator
  class Record
    attr_reader :path, :duration, :time, :bitrate, :rotation, :creation_time
    attr_reader :stream, :codec, :sample_rate
    attr_reader :container

    def initialize(path)
      fail Errno::ENOENT, "'#{path}' does not exist" unless File.exist?(path)
      @path = path

      # ffmpeg will output to stderr
      command = "#{Audiomator.ffmpeg} -i #{Shellwords.escape(@path)}"
      output = Open3.popen3(command) { |stdin, stdout, stderr| stderr.read }

      output[/Input \#\d+\,\s*(\S+),\s*from/]
      @container = $1

      output[/Duration: (\d{2}):(\d{2}):(\d{2}\.\d{2})/]
      @duration = ($1.to_i*60*60) + ($2.to_i*60) + $3.to_f

      output[/start: (\d*\.\d*)/]
      @time = $1 ? $1.to_f : 0.0

      output[/creation_time {1,}: {1,}(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/]
      @creation_time = $1 ? Time.parse("#{$1}") : nil

      output[/bitrate: (\d*)/]
      @bitrate = $1 ? $1.to_i : nil

      output[/Audio:\ (.*)/]
      @stream = $1

      if stream
        @codec, audio_sample_rate, @channels, unused, audio_bitrate = stream.split(/\s?,\s?/)
        @bitrate = audio_bitrate =~ %r(\A(\d+) kb/s) ? $1.to_i : nil
        @sample_rate = audio_sample_rate[/\d*/].to_i
      end

      @invalid = true if output.include?('is not supported')
      @invalid = true if output.include?('Invalid data found when processing input')
      @invalid = true if output.include?('could not find codec parameters')
    end

    def valid?
      !@invalid
    end

    def size
      File.size(@path)
    end
  end
end
