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
      ayahs = current_user.ayahs.where(:surah_id => surah_id )
      map_ayah_known = {}
      ayahs.each do |ayah|
        map_ayah_known[ayah.id] = ContentSurah.number_to_word ayah.known_value
      end
      map_ayah_known
    end
end