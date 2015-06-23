require 'spec_helper'
describe Audiomator::Record do
  before(:all) do
    @audio_file = File.expand_path('../../fixtures/tina_is_a_women-56kbps.m4a', __FILE__)
    @record = Audiomator::Record.new(@audio_file)
  end

  describe 'initializing' do
    context 'when file not exist' do
      it 'should raise an error' do
        expect { Audiomator::Record.new("i_dont_exist") }.to raise_error(Errno::ENOENT, /does not exist/)
      end
    end

    context 'when file exist' do
      it 'should get metadata successfully' do
        expect(@record.duration).to eql 1.54
        expect(@record.bitrate).to eql 56
      end

      it 'should know file size' do
        expect(@record.size).to eql 11904
      end

      it 'should be valid' do
        expect(@record.valid?).to be_truthy
      end

      it 'should know audio_sample_rate' do
        expect(@record.sample_rate).to eql 44100
      end

      it 'should know audio codec' do
        expect(@record.codec).to eql 'aac (LC) (mp4a / 0x6134706D)'
      end
    end

    context 'when file format not support' do
      before(:all) do
        @record = Audiomator::Record.new(__FILE__)
      end

      it 'should not be vaild' do
        expect(@record.valid?).to be_falsey
      end

      it 'should have duration 0.0' do
        expect(@record.duration).to eql 0.0
      end

      it 'should have bitrate nil' do
        expect(@record.bitrate).to eql nil
      end

      it 'should have audio_stream nil' do
        expect(@record.stream).to eql nil
      end
    end
  end
end