class CreateAyahs < ActiveRecord::Migration
  def change
    create_table :ayahs do |t|
      t.integer :position
      t.integer :surah_id

      t.timestamps
    end
  end
end
