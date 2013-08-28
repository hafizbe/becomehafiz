class CreateSurahs < ActiveRecord::Migration
  def change
    create_table :surahs do |t|
      t.integer :position
      t.integer :nb_versets

      t.timestamps
    end
  end
end
