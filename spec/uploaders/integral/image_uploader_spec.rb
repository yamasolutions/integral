require 'rails_helper'
require 'carrierwave/test/matchers'

module Integral
  describe ImageUploader do
    include CarrierWave::Test::Matchers

    let(:model) do
      m = build(:image, file: nil)
      m.process_file_upload = true
      m.file = Rack::Test::UploadedFile.new(File.join(Integral::Engine.root, 'spec', 'support', 'image.jpg'))
      m.save!
      m
    end
    let(:mounted_as) { 'avatar' }
    let(:instance) { described_class.new(model, mounted_as) }

    describe '#extension_white_list' do
      it 'has the correct whitelisted file formats' do
        expect(subject.extension_white_list).to eq ["jpg", "jpeg", "gif", "png"]
      end
    end

    describe '#store_dir' do
      it 'has the correct storage directory' do
        expect(instance.store_dir).to end_with "uploads/integral/image/#{mounted_as}/#{model.id}"
      end
    end

    describe 'callbacks' do
      before do
        described_class.enable_processing = true
      end

      after do
        described_class.enable_processing = false
      end

      context 'Integral::Image' do
        it 'stores height, width and file size properties' do
          expect(model.height).to be_truthy
          expect(model.width).to be_truthy
          expect(model.file_size).to be_truthy
        end
      end
    end
  end
end
