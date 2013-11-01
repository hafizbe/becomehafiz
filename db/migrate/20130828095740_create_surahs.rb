class CreateSurahs < ActiveRecord::Migration
  def change
    create_table :surahs do |t|
      t.integer :id
      t.integer :nb_versets
      t.string :position
      t.string :name_arabic
      t.string :name_phonetic
      t.string :type_surah
      t.timestamps
    end
  end
  def self.down
    drop_table :surahs
  end
end
