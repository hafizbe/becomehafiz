class SurahsController < ApplicationController
include Amazon
def index
  # Selected Value

  @form_player_option = FormPlayerOption.new(params[:lstSurahs], params[:lstFromVersets],
                         params[:lstToVersets], params[:lstToVersetsCheck], params[:lstRecitators],
                         params[:lstTraduction], params[:lstSize])
  if user_signed_in?
    @form_player_option.map_ayah_known = get_ayah_with_known_classe @form_player_option.surah_id
    @form_player_option.user_signed = 1
    @form_player_option.user_id = current_user.id
  end
end

  private




  def get_ayah_with_known_classe(surah_id)

    range = current_user.ayahs.where(:surah_id => surah_id).map(&:id).join(' ,')
    ayah_relationships = nil
    unless range.empty?
      ayah_relationships = current_user.ayah_relationships.where("ayah_id IN (#{range}) ")
    end
    map_ayah_known = {}
    unless ayah_relationships == nil
      ayah_relationships.each do |ayah_relationship|
        map_ayah_known[ayah_relationship.ayah_id] = number_to_word ayah_relationship.known_value
      end
    end
    map_ayah_known
  end

  def number_to_word(number)
    word = ""
    if number == 1
      word = "very_good"
    else if number == 2
     word = "good"
     else if number == 3
          word = "bad"
        end
      end
    end
  end

end