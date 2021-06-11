# This migration comes from lightning (originally 20210611132548)
class AddFeatureOptCriterionTable < ActiveRecord::Migration[5.0]
  def change
    create_table :lightning_feature_opt_criterions do |t|
      t.integer :feature_id, null: false
      t.string :entity_type, null: false
      t.string :entity_method, null: false

      t.timestamps
    end

    add_index :lightning_feature_opt_criterions, [:entity_type, :entity_method], name: 'criterion_entity_index'
    add_index :lightning_feature_opt_criterions, [:feature_id, :entity_type, :entity_method], unique: true, name: 'criterion_uniq_index'

  end
end
