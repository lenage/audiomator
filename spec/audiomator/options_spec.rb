require 'spec_helper'
describe Audiomator::Options do

  it 'should return correct options' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48', '56k')
    expect(options.to_s).to be_kind_of String
  end

  it 'default bitrate should be 32k' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48')
    expect(options.bitrate).to eql '32k'
    expect(options.to_s).to include '-b:a 32k'
  end

  it 'should be able set metadata' do
    metadata = { title: 'This is Tina' }
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48', nil, metadata)
    expect(options.metadata).to eql metadata
    expect(options.metadata_string).to be_kind_of String
    expect(options.metadata_string).to include "Tina"
  end
end
