class FormPlayerOption
  include Amazon
  attr_accessor :surah_id, :verset_maximum, :verset_minimum, :recitator_name, :langue_selected, :size,
                :langues, :content_surah, :sourates_list, :recitators_list, :map_ayah_known, :user_signed,
                :user_id, :ayahs_ids

  def initialize(lst_surah_id, lst_from_versets, lst_to_versets, lst_to_versets_check, lst_recitator_name, lst_traduction_name, lst_size)
    @surah_id = choose_surah_id lst_surah_id
    @verset_maximum = choose_verset_maximum @surah_id.to_i, lst_to_versets,  lst_to_versets_check
    @verset_minimum = choose_verset_minimum lst_from_versets
    @recitator_name = choose_recitator_name lst_recitator_name
    @langue_selected = choose_traduction lst_traduction_name
    @size = choose_size lst_size
    @langues = get_langue


    @map_ayah_known = {}
    @user_signed = 0
    @user_id = 0

    @content_surah = ContentSurah.new @surah_id, @verset_minimum, @verset_maximum, @langue_selected

    # Dropdown Value
    @sourates_list  = get_name_surahs # On récupère toutes les sourates à afficher dans la liste déroulante
    @recitators_list = get_name_recitators # Récupère recitateurs pour la liste déroulante
  end

  private
    def choose_verset_minimum(lst_from_versets)
      verset_minimum = 1
      unless lst_from_versets.nil?
        verset_minimum = lst_from_versets
      end
      verset_minimum
    end

    def choose_verset_maximum(lst_id_surah, lst_to_versets, lst_to_versets_check)
      h = Hash.new()
      last_ayah = Surah.find(lst_id_surah).nb_versets
      h["max"] = last_ayah
      h["max_selected"] = last_ayah
      unless lst_to_versets.nil? || lst_to_versets_check == 0.to_s
        h["max_selected"] = lst_to_versets
      end
      h
    end

    def choose_surah_id(lst_surah_id)
      surah_id = 1
      unless lst_surah_id.nil?
        surah_id = lst_surah_id
      end
      surah_id
    end

    def choose_recitator_name(lst_recitator_name)
      recitator_name = "Mishary"
      unless lst_recitator_name.nil?
        recitator_name  = lst_recitator_name
      end
      recitator_name
    end

    def choose_traduction(lst_traduction_name)
      traduction = "none"
      unless lst_traduction_name.nil?
        traduction  = lst_traduction_name
      end
      traduction
    end

    def choose_size(lst_size)
      size = "medium"
      unless lst_size.nil?
        size  = lst_size
      end
      size
    end

    def get_name_surahs
      map_surahs = {}
      Surah.all.each do |surah|
        map_surahs["#{surah.position} - #{surah.name_phonetic} | #{surah.name_arabic}"] = surah.position.to_i
      end
      map_surahs
    end

    def get_name_recitators
      mapRecitators = {}
      Recitator.all.each do |recitator|
        mapRecitators[recitator.name] = recitator.value
      end
      mapRecitators
    end

    def get_langue
      hm = {}
      hm['none'] = 'None'
      hm['fr'] = 'French'
      hm['en'] = 'English'
      hm['es'] = 'Spanish'
      hm
    end
end