require "rails_helper"
require "generators/integral/assets_generator"
require "generator_spec"

module Integral
  module Generators
    describe AssetsGenerator, type: :generator do
      destination File.expand_path("../../tmp", __FILE__)

      context 'with default arguments' do
        before(:all) do
          prepare_destination
          run_generator
        end

        it 'creates frontend asset files' do
          assert_file 'app/assets/javascripts/integral/frontend.js'
          assert_file 'app/assets/stylesheets/integral/frontend.sass'
          assert_directory 'app/assets/stylesheets/integral/frontend'
        end

        it 'does not create backend asset files' do
          assert_no_file 'app/assets/javascripts/integral/backend.js'
          assert_no_file 'app/assets/stylesheets/integral/backend.sass'
          assert_no_directory 'app/assets/stylesheets/integral/backend'
        end

        it 'does not create email asset files' do
          assert_no_file 'app/assets/stylesheets/integral/emails.scss'
          assert_no_directory 'app/assets/stylesheets/integral/emails'
        end
      end

      context 'with generate all asset arguments' do
        before(:all) do
          prepare_destination
          run_generator %w(-a backend frontend email)
        end

        it 'creates frontend asset files' do
          assert_file 'app/assets/javascripts/integral/frontend.js'
          assert_file 'app/assets/stylesheets/integral/frontend.sass'
          assert_directory 'app/assets/stylesheets/integral/frontend'
        end

        it 'creates backend asset files' do
          assert_file 'app/assets/javascripts/integral/backend.js'
          assert_file 'app/assets/stylesheets/integral/backend.sass'
          assert_directory 'app/assets/stylesheets/integral/backend'
        end

        it 'creates email asset files' do
          assert_file 'app/assets/stylesheets/integral/emails.scss'
          assert_directory 'app/assets/stylesheets/integral/emails'
        end
      end
    end
  end
end
