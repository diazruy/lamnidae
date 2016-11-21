class CreateIntegrationKeys < ActiveRecord::Migration
  def change
    create_table :integration_keys do |t|
      t.references :user
      t.string :source
      t.string :key

      t.timestamps
    end
    add_index :integration_keys, [:user_id, :source]
  end
end
