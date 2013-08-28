class AddNamePhoneticToSurah < ActiveRecord::Migration
  def change
    add_column :surahs, :name_phonetic, :string
  end
end
