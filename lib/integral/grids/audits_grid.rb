module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Audit filtering & sorting
    class AuditsGrid
      include Datagrid

      scope do
        Integral::Lighthouse::Audit.order('updated_at DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      filter(:auditable_type, multiple: true) do |value|
        where(auditable_type: value)
      end

      column(:url, order: :url)
      column(:performance_score, order: :performance_score)
      column(:auditable)
      column(:created_at, order: :created_at)
      column(:updated_at)
      column(:actions)
    end
  end
end
