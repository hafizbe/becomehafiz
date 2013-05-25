class Surah < ActiveRecord::Base
  attr_accessible :ayahId, :ayahText, :name, :surahId

  #Retourne les versets en fonctions de l'id de la sourate donnée en paramètre
  def self.getAyahs(surah_id)
    tab = Surah.where(:surahId => surah_id).order("ayahId")
    retour = []

    tab.each do |ayah|
      retour << ayah
    end
    retour

  end

  #Retourne le nom de toutes les sourates
  def self.getNameSurah
    cpt = 1.to_i

    tab = Surah.select("name, surahId").group("name, surahId").order("surahId")
    retour = Hash.new
    tab.each do |surah|
      retour[surah.surahId] = surah.name
      cpt = cpt + 1
    end
    retour
  end
end
