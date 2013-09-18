class ContentSurah
include Amazon
  attr_accessor :surah_id, :ayahs_arabic, :ayahs_traducted, :ayahs_ids
  def initialize(surah_id, from_ayah_min, to_ayah_max, lst_traduction)
   @surah_id = surah_id
   @ayahs_arabic = Surah.getAyahs id_surah_to_string(@surah_id), from_ayah_min.to_i, to_ayah_max["max_selected"].to_i
   @ayahs_traducted = get_traduction id_surah_to_string(@surah_id), lst_traduction
   @ayahs_ids = Surah.get_ayahs_ids @surah_id, from_ayah_min, to_ayah_max["max"]
  end

  # Retourne un tableau avec la traduction de chaque verset
  def get_traduction(num_sourate, lst_traduction)
    tab_verset = nil
    unless  lst_traduction.nil? or lst_traduction == "none"
      require 'open-uri'
      s3 = AWS::S3.new
      url = s3.buckets['hafizbe'].objects["traduction/#{lst_traduction}/Chapter#{num_sourate}.xml"].url_for(:read, :secure => false).to_s
      document = Nokogiri::XML(open(url))
      versets = document.xpath("//Verse/text()")
      tab_verset = []
      versets.each do |verset|
        tab_verset << verset.text()
      end
      tab_verset
    end
  end
end