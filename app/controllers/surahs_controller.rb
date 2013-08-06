class SurahsController < ApplicationController
  include Amazon
  def index
    @from_verset_minimum = choose_verset_minimum


    @versets_traduit = get_traduction "fr" , "001"
    @langues = get_langue



    @surah_id = choose_surahId # On determine l'id de la sourate à afficher
    getNameSurah # On récupère toutes les sourates à afficher dans la liste déroulante


    @from_verset_maximum = choose_verset_maximum @surah_id

    @recitator_name = choose_recitator_name # On détermine le recitator
    getNameRecitators # Récupère recitateurs pour la liste déroulante

    @versets = Surah.getAyahs @surah_id,@from_verset_minimum.to_i,@from_verset_maximum["max_selected"].to_i
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {:versets => @versets,
              :from_verset_maximum => @from_verset_maximum, :from_verset_minimum => @from_verset_minimum }}
    end
  end


  private

  def get_langue
    hm = {}
    hm['fr'] = 'French'
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
    val = Surah.get_last_ayah_from_surah  id_surah
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

  def getNameSurah
    @sourates_list = Surah.getNameSurah
  end

  def choose_recitator_name
    recitator_name = "Mishary"
    unless params[:lstRecitators].blank?
      recitator_name  = params[:lstRecitators]
    end
    recitator_name
  end

  def getNameRecitators
    @mapRecitators = {}
    Recitator.all.each do |recitator|
     @mapRecitators[recitator.name] = recitator.value
    end
    @mapRecitators
  end

end