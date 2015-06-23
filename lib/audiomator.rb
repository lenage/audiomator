require 'logger'

require 'audiomator/error'
require 'audiomator/options'
require 'audiomator/record'
require 'audiomator/version'

# Main module for Audiomator
module Audiomator
  # Set FFMPEG logs about its process when it's transcoding
  # @params {logger} log you own logger
  # @return [Logger] the logger you ser
  def self.logger=(log)
    @logger = log
  end

  # Get FFMPEG logger.
  #
  # @return [Logger]
  def self.logger
    return @logger if @logger
    logger = ::Logger.new(STDOUT)
    logger.level = ::Logger::INFO
    @logger = logger
  end

  # Set the path of ffmpeg
  # Can be useful if you need to specify a path as /usr/local/bin/ffmpeg
  #
  # @param [String] path to the ffmpeg
  # @return [String] the path of ffmpeg
  def self.ffmpeg=(bin)
    @ffmpeg = bin
  end

  def self.ffmpeg
    @ffmpeg || 'ffmpeg'
  end
end
