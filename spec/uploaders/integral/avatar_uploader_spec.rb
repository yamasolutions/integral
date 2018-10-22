require 'rails_helper'
require 'carrierwave/test/matchers'

module Integral
  describe AvatarUploader do
    include CarrierWave::Test::Matchers

    it { expect(described_class).to be < ImageUploader }

    # Temp commented out as it is causing dummy app to blow up about missing Materialize dependancy (?)
    # describe '#default_url' do
    #   it 'has correct default_url' do
    #     expect(subject.default_url).to eq '/default_avatar.jpg'
    #   end
    # end
  end
end
