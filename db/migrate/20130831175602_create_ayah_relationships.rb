class CreateAyahRelationships < ActiveRecord::Migration
  def change
    create_table :ayah_relationships do |t|
      t.integer :ayah_id
      t.string :user_id
      t.string :integer
      t.integer :known_value

      t.timestamps
    end
  end
end
