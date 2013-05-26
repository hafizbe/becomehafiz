class RenameUnderscore < ActiveRecord::Migration
  def self.up
    rename_column :surahs, :surahId, :surah_id
    rename_column :surahs, :ayahId, :ayah_id
  end
end