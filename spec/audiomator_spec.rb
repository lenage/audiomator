require 'spec_helper'

describe Audiomator do
  it 'has a version number' do
    expect(Audiomator::VERSION).not_to be nil
  end

  it 'should be able to set logger' do
    expect(Audiomator).to respond_to('logger=')
  end

  it 'should be able to set ffmpeg' do
    path = '/some/path'
    Audiomator.ffmpeg = path
    expect(Audiomator).to respond_to('ffmpeg=')
    expect(Audiomator.ffmpeg).to eql path
  end
end
