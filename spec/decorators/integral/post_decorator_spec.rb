require 'rails_helper'

module Integral
  describe PostDecorator do
    let(:post) { create(:integral_post, status: 1, tag_list: 'foo-tag,bar-tag') }

    subject { described_class.new(post) }

    describe '#backend_url' do
      context 'when blog enabled' do
        it 'provides the URL' do
          expect(subject.backend_url).to eq "http://test.somehost.com/admin/posts/#{post.id}/edit"
        end
      end

      context 'when blog not enabled' do
        it 'provides empty string' do
          Integral.blog_enabled = false
          expect(subject.backend_url).to eq ''
          Integral.blog_enabled = true
        end
      end
    end

    describe '#activity_url' do
      context 'when blog enabled' do
        it 'provides the URL' do
          expect(subject.activity_url(1)).to eq "http://test.somehost.com/admin/posts/2/activities/1"
        end
      end

      context 'when blog not enabled' do
        it 'provides empty string' do
          Integral.blog_enabled = false
          expect(subject.activity_url(1)).to eq ''
          Integral.blog_enabled = true
        end
      end
    end

    describe '#header_tags' do
      context 'when no tags exist' do
        let(:post) { create(:integral_post, status: 1, tag_list: '') }
        it 'returns subtitle' do
          expect(subject.header_tags).to eq I18n.t('integral.posts.show.subtitle')
        end
      end

      context 'when tags exist' do
        it 'returns tags' do
          expect(subject.header_tags).to eq 'foo-tag | bar-tag'
        end
      end
    end

    describe '#published_at' do
      context 'when published' do
        it 'returns formatted published date' do
          expect(subject.published_at).to eq I18n.l(post.published_at, format: :blog)
        end
      end

      context 'when not published' do
        let(:post) { create(:integral_post, status: 0) }

        it 'returns not published' do
          expect(subject.published_at).to eq 'Not yet published'
        end
      end
    end

    describe '#body' do
      it 'returns formatted body' do
        expect(subject.body).to eq post.body
      end
    end

    describe '#image' do
      context 'when image is available' do
        it 'returns image URL' do
          expect(subject.image).to eq post.image.url(:small)
        end
      end

      # context 'when image is not available' do
      #   it 'returns default image' do
      #     allow(post).to receive(:image).and_return(double(url: nil))
      #     expect(subject.image).to eq Integral::BaseController::Base.helpers.image_url('integral/defaults/no_image_available.jpg')
      #   end
      # end
    end
  end
end
