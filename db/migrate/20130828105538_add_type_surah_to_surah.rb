class AddTypeSurahToSurah < ActiveRecord::Migration
  def change
    add_column :surahs, :type_surah, :string
  end
end
