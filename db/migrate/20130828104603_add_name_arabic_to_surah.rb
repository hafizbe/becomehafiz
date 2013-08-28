class AddNameArabicToSurah < ActiveRecord::Migration
  def change
    add_column :surahs, :name_arabic, :string
  end
end
