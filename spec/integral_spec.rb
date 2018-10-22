require "rails_helper"

module Integral
  describe "#configure" do
    let(:foo) { '' }

    context 'black_listed_paths' do
      context 'when setting is set' do
        let(:black_listed_paths) { [ '/test1', '/test2' ] }

        before do
          Integral.configure do |config|
            config.black_listed_paths = black_listed_paths
          end
        end

        it 'attempting to create a page under the black listed paths fails' do
          expect(build(:integral_page, path: '/test1/').valid?).to be false
          expect(build(:integral_page, path: '/test2/').valid?).to be false
          expect(build(:integral_page, path: '/admin/').valid?).to be true
        end
      end
    end
  end
end
