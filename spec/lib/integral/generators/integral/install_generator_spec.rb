require "rails_helper"
require "generators/integral/install_generator"
require "generator_spec"

module Integral
  module Generators
    describe InstallGenerator, type: :generator do
      destination File.expand_path("../../tmp", __FILE__)

      before(:all) do
        prepare_destination
        run_generator
      end

      it "creates an initializer" do
        assert_file "config/initializers/integral.rb"
      end

      it "creates a default settings file" do
        assert_file "config/app.yml"
      end

      it "creates a default Carrierwave initializer" do
        assert_file "config/initializers/carrierwave.rb"
      end

      it "creates a default Sitemap Generator file" do
        assert_file "config/sitemap.rb"
      end

      it "creates a default routes file" do
        assert_file "config/routes.rb"
      end

      it "creates a default seeds file" do
        assert_file "db/seeds.rb"
      end
    end
  end
end
