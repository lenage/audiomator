require 'timeout'
require 'time'
require 'shellwords'
require 'open3'
require 'audiomator/options'

module Audiomator
  class Record
    attr_reader :path, :duration, :time, :bitrate, :rotation, :creation_time
    attr_reader :stream, :codec, :sample_rate
    attr_reader :container

    def initialize(path)
      fail Errno::ENOENT, "'#{path}' does not exist" unless File.exist?(path)
      @path = path

      # ffmpeg will output to stderr
      @output = Open3.popen3(ffmpeg_command) { |_stdin, _stdout, stderr| stderr.read }

      parse_container
      parse_duration
      parse_time
      parse_creation_time
      parse_stream_info
      validate
    end

    def valid?
      !@invalid
    end

    def size
      File.size(@path)
    end

    def basename
      File.basename(@path, '.*')
    end

    def clip(start_time, end_time, output = nil, options = {})
      options = default_clip_options.merge!(options)
      output = output_file(start_time, end_time, options) unless output
      opts = Options.new(start_time, end_time, options[:bitrate], options[:metadata])
      command = [ffmpeg_command, opts.to_s, output].join(' ')
      Audiomator.logger.info("Running audio processing...\n #{command}\n")
      @output_error = ''

      begin
        Timeout.timeout(Audiomator.timeout) do
          _stdout, stderr, status = Open3.capture3(command)
          @output_error = stderr
          unless status.success?
            fail Error, "Proecess Failed, Full output: #{stderr}"
          end
        end
      rescue Timeout::Error => e
        raise Error, "Proecess Timeout #{e.message} \n: #{@output_error} \n"
      end
    end

    private

    def output_file(start_time, end_time, options = default_clip_options)
      output_filename = "#{basename}-#{duration}-#{start_time}_#{end_time}.#{options[:format]}"
      File.join File.dirname(@path), output_filename
    end

    def default_clip_options
      { bitrate: '32k', format: 'm4a', metadata: {} }
    end

    def ffmpeg_command
      "#{Audiomator.ffmpeg} -i #{Shellwords.escape(@path)}"
    end

    def parse_container
      @output[/Input \#\d+\,\s*(\S+),\s*from/]
      @container = $1
    end

    def parse_duration
      @output[/Duration: (\d{2}):(\d{2}):(\d{2}\.\d{2})/]
      @duration = ($1.to_i * 60 * 60) + ($2.to_i * 60) + $3.to_f
    end

    def parse_time
      @output[/start: (\d*\.\d*)/]
      @time = $1 ? $1.to_f : 0.0
    end

    def parse_creation_time
      @output[/creation_time {1,}: {1,}(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/]
      @creation_time = $1 ? Time.parse("#{$1}") : nil
    end

    def parse_bitrate
      @output[/bitrate: (\d*)/]
      @bitrate = $1 ? $1.to_i : nil
    end

    def parse_stream_info
      @output[/Audio:\ (.*)/]
      @stream = $1
      if stream
        @codec, audio_sample_rate, @channels, _, audio_bitrate = stream.split(/\s?,\s?/)
        @bitrate = audio_bitrate =~ %r(\A(\d+) kb/s) ? $1.to_i : nil
        @sample_rate = audio_sample_rate[/\d*/].to_i
      end
    end

    def validate
      @invalid = true if @output.include?('is not supported')
      @invalid = true if @output.include?('Invalid data found when processing input')
      @invalid = true if @output.include?('could not find codec parameters')
    end
  end
end
