class CreateAyahRelationship < ActiveRecord::Migration
  def up
    create_table :ayah_relationships do |t|
      t.integer :ayah_id
      t.integer :user_id
      t.integer :known_value, :default => 0

      t.timestamps
    end
    add_index :ayah_relationships, :ayah_id
    add_index :ayah_relationships, :user_id
    add_index :ayah_relationships, [:ayah_id, :user_id], :unique => true
  end

  def down
    drop_table :ayah_relationships
  end
end
