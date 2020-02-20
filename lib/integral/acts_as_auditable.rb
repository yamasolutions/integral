module Integral
  # Handles Auditable behaviour
  module ActsAsAuditable
    class << self
      # Keeps a track of auditable objects
      attr_writer :objects
     end

    # Accessor for auditable objects
    def self.objects
      @objects ||= []
    end

    ActiveSupport.on_load(:active_record) do
      # ActiveRecord::Base extension
      class ActiveRecord::Base
        # Adds auditable behaviour to objects
        def self.acts_as_auditable(_options = {})
          Integral::ActsAsAuditable.objects << self

          # Scope to eligible records
          def self.auditable_scope
            all
          end

          # @return [String] path to audit
          def auditable_path
            raise NotImplementedError
          end

          has_many :audits, as: :auditable, class_name: 'Integral::Lighthouse::Audit'
        end
      end
    end
  end
end
