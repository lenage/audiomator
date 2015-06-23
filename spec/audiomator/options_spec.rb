require 'spec_helper'
describe Audiomator::Options do

  it 'should return correct options' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48', '56k')
    expect(options.to_s).to be_kind_of String
  end

  it 'default bitrate should be 32k' do
    options = Audiomator::Options.new('0:00:06.98', '0:00:08.48')
    expect(options.bitrate).to eql '32k'
  end
end
