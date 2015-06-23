module Audiomator
  # Options which convert audio to
  class Options < Struct.new(:start_time, :end_time, :bitrate)
    def initialize(start_time, end_time, bitrate = '32k')
      super
    end

    def to_s
      "-b:a #{bitrate} -ss #{start_time} -to #{end_time}"
    end
  end
end
