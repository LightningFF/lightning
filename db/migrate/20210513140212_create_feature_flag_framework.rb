class CreateFeatureFlagFramework < ActiveRecord::Migration[5.2]
  def change
    create_table :lightning_features do |t|
      t.string :key, index: { unique: true }, null: false
      t.text :description
      t.integer :state, default: 0, null: false

      t.timestamps
    end

    create_table :lightning_feature_opt_ins do |t|
      t.integer :feature_id, null: false
      t.integer :entity_id, null: false
      t.string :entity_type, null: false

      t.timestamps
    end

    add_index :lightning_feature_opt_ins, [:entity_id, :entity_type]
    add_index :lightning_feature_opt_ins, [:feature_id, :entity_id, :entity_type], unique: true, name: 'opt_in_index'
  end
end
