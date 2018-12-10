require "rails_helper"
require "generators/integral/views_generator"
require "generator_spec"

module Integral
  module Generators
    describe ViewsGenerator, type: :generator do
      destination File.expand_path("../../tmp", __FILE__)

      context 'with default arguments' do
        before(:all) do
          prepare_destination
          run_generator
        end

        it 'creates frontend view files' do
          assert_directory "app/views/integral/pages"
          assert_directory "app/views/integral/posts"
          assert_directory "app/views/integral/tags"
          assert_directory "app/views/integral/shared"
          assert_directory "app/views/layouts/integral/frontend"
          assert_file 'app/views/layouts/integral/frontend.html.haml'
        end

        it 'does not create backend views files' do
          assert_no_directory "app/views/integral/backend"
        end
      end

      context 'with generate all views arguments' do
        before(:all) do
          prepare_destination
          run_generator %w(-v backend frontend devise mailer)
        end

        it 'creates frontend view files' do
          assert_directory "app/views/integral/pages"
          assert_directory "app/views/integral/posts"
          assert_directory "app/views/integral/tags"
          assert_directory "app/views/integral/shared"
          assert_directory "app/views/layouts/integral/frontend"
          assert_file 'app/views/layouts/integral/frontend.html.haml'
        end

        it 'creates backend views files' do
          assert_directory "app/views/integral/backend"
          assert_directory "app/views/layouts/integral/backend"
          assert_file "app/views/layouts/integral/backend.html.haml"
        end

        it 'creates mailer views files' do
          assert_directory "app/views/integral/contact_mailer"
          assert_directory "app/views/layouts/integral/mailer"
          assert_file "app/views/layouts/integral/mailer.html.inky-haml"
        end

        it 'creates devise views files' do
          assert_directory "app/views/devise"
          assert_file "app/views/layouts/integral/login.haml"
        end
      end
    end
  end
end
