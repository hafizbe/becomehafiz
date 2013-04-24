class CreateSurahs < ActiveRecord::Migration
  def change
    create_table :surahs do |t|
      t.string :name
      t.integer :surahId
      t.integer :ayahId
      t.text :ayahText

      t.timestamps
    end
  end
end
