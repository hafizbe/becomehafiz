class Surah < ActiveRecord::Base
  attr_accessible :ayahId, :ayahText, :name, :surah_id

  #Retourne les versets en fonctions de l'id de la sourate donnée en paramètre

  def self.getAyahs(surah_id,from_verset, to_verset)
    include Amazon
    require 'open-uri'
    s3 = AWS::S3.new
    url = s3.buckets['hafizbe'].objects["surah_content/Chapter#{surah_id}.xml"].url_for(:read, :secure => false).to_s
    doc_xml = Nokogiri::XML(open url)
    tab_content_aya = []
    doc_xml.xpath("//Verse[@VerseID >= #{from_verset} and @VerseID <=#{to_verset}]").each do |verse|
      tab_content_aya << verse.text()
    end
    tab_content_aya

  end

  def self.get_last_ayah_from_surah(id_surah)
    require 'open-uri'
    s3 = AWS::S3.new
    url = s3.buckets['hafizbe'].objects["surah_content/Chapter#{id_surah}.xml"].url_for(:read, :secure => false).to_s
    doc_xml = Nokogiri::XML(open url)
    last_verse = doc_xml.xpath("//Verse[last()]").attr("VerseID").text().to_i
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
