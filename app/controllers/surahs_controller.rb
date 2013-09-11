class SurahsController < ApplicationController
include Amazon
def index
  # Selected Value
  @from_verset_minimum = choose_verset_minimum
  @surah_id = choose_surahId # On determine l'id de la sourate à afficher
  @from_verset_maximum = choose_verset_maximum @surah_id
  @recitator_name = choose_recitator_name # On détermine le recitator
  @langue_selected = choose_traduction
  @size = choose_size #Détermine la taille de la police d'écriture

  # Dropdown Value
  @sourates_list = getNameSurah # On récupère toutes les sourates à afficher dans la liste déroulante
  @recitators_list = getNameRecitators # Récupère recitateurs pour la liste déroulante
  @langues = get_langue

  # Content
  @versets_traduit = get_traduction(id_surah_to_string(@surah_id))
  @versets = Surah.getAyahs id_surah_to_string(@surah_id),@from_verset_minimum.to_i,@from_verset_maximum["max_selected"].to_i
  @ayahs_ids = Surah.get_ayahs_ids @surah_id, @from_verset_minimum, @from_verset_maximum["max"]
  @user_signed =  user_signed_in? ? 1 : 0

  respond_to do |format|
    format.html # index.html.erb
    format.json { render :json => {:versets => @versets,
            :from_verset_maximum => @from_verset_maximum, :from_verset_minimum => @from_verset_minimum }}
  end
end

  private

  # Retourne un tableau avec la traduction de chaque verset
  def get_traduction(num_sourate)
    tab_verset = nil
    unless  params[:lstTraduction].blank? or params[:lstTraduction] == "none"
      require 'open-uri'
      s3 = AWS::S3.new
      url = s3.buckets['hafizbe'].objects["traduction/#{params[:lstTraduction]}/Chapter#{num_sourate}.xml"].url_for(:read, :secure => false).to_s
      document = Nokogiri::XML(open(url))
      versets = document.xpath("//Verse/text()")
      tab_verset = []
      versets.each do |verset|
        tab_verset << verset.text()
      end
      tab_verset
    end
  end

  def get_langue
    hm = {}
    hm['none'] = 'None'
    hm['fr'] = 'French'
    hm['en'] = 'English'
    hm['es'] = 'Spanish'
    hm
  end

  def choose_verset_minimum
    val = 1
    unless params[:lstFromVersets].blank?
      val = params[:lstFromVersets]
    end
    val
  end

  # Retourne hashmap avec le dernier verset ainsi que le dernier verset sélectionné
  def choose_verset_maximum(id_surah)
    h = Hash.new()
    val = Surah.get_last_ayah_from_surah  id_surah_to_string id_surah
    h["max"] = val
    h["max_selected"] = val
    unless params[:lstToVersets].blank? || params[:lstToVersetsCheck] == 0.to_s
      h["max_selected"] = params[:lstToVersets]
    end
    h
  end

  def choose_surahId
    surah_id = 1
    unless params[:lstSurahs].blank?
      surah_id = params[:lstSurahs]
    end
    surah_id
  end

  def choose_traduction
    lang = 'none'
    unless params[:lstTraduction].blank?
      lang = params[:lstTraduction]
    end
    lang
  end

  def getNameSurah
    map_surahs = {}
    Surah.all.each do |surah|
      map_surahs["#{surah.position} - #{surah.name_phonetic} | #{surah.name_arabic}"] = surah.position
    end
    map_surahs
  end

  def choose_recitator_name
    recitator_name = "Mishary"
    unless params[:lstRecitators].blank?
      recitator_name  = params[:lstRecitators]
    end
    recitator_name
  end

  def choose_traduction
    traduction = "none"
    unless params[:lstTraduction].blank?
      traduction  = params[:lstTraduction]
    end
    traduction
  end
  def getNameRecitators
    mapRecitators = {}
    Recitator.all.each do |recitator|
     mapRecitators[recitator.name] = recitator.value
    end
    mapRecitators
  end

  def choose_size
    size = "medium"
    unless params[:lstSize].blank?
      size  = params[:lstSize]
    end
    size
  end

end