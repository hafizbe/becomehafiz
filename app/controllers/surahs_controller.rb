class SurahsController < ApplicationController

  def index
    @surah_id = choose_surahId # On determine l'id de la sourate à afficher
    getNameSurah # On récupère toutes les sourates à afficher dans la liste déroulante

    @recitator_name = choose_recitator_name # On détermine le recitator
    getNameRecitators # Récupère recitateurs pour la liste déroulante

    initialize_amazon(@recitator_name, @surah_id)

    @versets = Surah.getAyahs @surah_id
  end

  # Permet de transformer les "1" en "001" car toutesles sourates sont présentées sous la forme "001.mp3"
  def countNumber(number)
    if number.to_s.size == 1
      number = "00#{number}"
    else
      if number.to_s.size == 2
        number = "0#{number}"
      end
    end
    number
  end

  protected

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
    recitator_name = "michary_rachid"
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

  def initialize_amazon(recitateur, surah_id)
    s3 = AWS::S3.new
    surah_id_amazon =  self.countNumber(surah_id)
    @surah_mp3 = s3.buckets['hafizbe'].objects["#{recitateur}/#{surah_id_amazon}.mp3"]
  end

end