class Surah < ActiveRecord::Base
  attr_accessible :ayahId, :ayahText, :name, :surah_id

  #Retourne les versets en fonctions de l'id de la sourate donnée en paramètre
  def self.getAyahs(surah_id,from_verset, to_verset)
    tab = Surah.where(:surah_id => surah_id, :ayah_id => from_verset..to_verset).order('ayah_id')
    retour = []

    tab.each do |ayah|
      retour << ayah
    end
    retour

  end

  def self.get_last_ayah_from_surah(id_surah)
    aya = Surah.where(:surah_id => id_surah).order('ayah_id').last
    aya.ayah_id
  end

  #Retourne le nom de toutes les sourates
  def self.getNameSurah
    cpt = 1.to_i

    tab = Surah.select('name, surah_id').group('name, surah_id').order('surah_id')
    retour = Hash.new
    tab.each do |surah|
      retour[surah.surah_id] = surah.name
      cpt = cpt + 1
    end
    retour
  end
end
