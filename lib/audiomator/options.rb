require 'shellwords'
module Audiomator
  # Options which convert audio to
  class Options < Struct.new(:start_time, :end_time, :bitrate, :sample_rate, :metadata)

    def initialize(start_time, end_time, bitrate = '96k', sample_rate = '44100', metadata = {})
      super
    end

    # see http://multimedia.cx/eggs/supplying-ffmpeg-with-metadata/ for metadata
    def metadata_string
      return '' if metadata.empty?
      metadata.map { |k, v| "-metadata #{k}=#{Shellwords.escape(v)}" }.join(' ')
    end

    def to_s
      "-b:a #{bitrate} -ar #{sample_rate} -ss #{start_time} -to #{end_time} #{metadata_string}"
    end
  end
end
