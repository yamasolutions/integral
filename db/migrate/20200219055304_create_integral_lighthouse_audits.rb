class CreateIntegralLighthouseAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :integral_lighthouse_audits do |t|
      t.string :url, null: false
      t.string :emulated_form_factor
      t.string :throttling_method
      t.string :categories

      t.decimal :performance_score
      t.decimal :accessibility_score
      t.decimal :best_practices_score
      t.decimal :pwa_score
      t.decimal :seo_score

      t.jsonb :response, null: false, default: '{}'

      # (automated index name is too long)
      t.references :auditable, polymorphic: true, index: { name: 'index_integral_lighthouse_audits_on_auditable_type_id' }

      t.timestamps
    end
  end
end
