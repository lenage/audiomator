require 'spec_helper'
describe Audiomator::Options do

  it 'should return correct options' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48', '56k')
    expect(options.to_s).to be_kind_of String
  end

  it 'default bitrate should be 96k' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48')
    expect(options.bitrate).to eql '96k'
    expect(options.to_s).to include '-b:a 96k'
  end

  it 'default sample_rate should be 44100' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48')
    expect(options.sample_rate).to eql '44100'
    expect(options.to_s).to include '-ar 44100'
  end

  it 'should be able to set metadata' do
    metadata = { title: 'This is Tina' }
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48', nil, nil, metadata)
    expect(options.metadata).to eql metadata
    expect(options.metadata_string).to be_kind_of String
    expect(options.metadata_string).to include "Tina"
  end
end
