module Integral
  # Base Integral Model.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
