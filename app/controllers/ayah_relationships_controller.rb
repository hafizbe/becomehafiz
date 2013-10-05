class AyahRelationshipsController < ApplicationController
  before_filter :authenticate_user!
  def create
    if User.find(params[:id]) == current_user
      ayah_relationship = current_user.ayah_relationships.build(:ayah_id => params[:current_aya_id],
                                                                :known_value => params[:known_value])
    end
    respond_to do |format|
      if ayah_relationship.save
        surah = Ayah.find(params[:current_aya_id]).surah
        known_of_surah = current_user.ayahs_knowns_per_surah surah.id
        format.json { render :json => known_of_surah }
      else
        format.json { render :json => false}
      end

    end
  end

  def update
    if User.find(params[:id]) == current_user
      ayah_relationship =  AyahRelationship.where(:ayah_id => params[:current_aya_id], :user_id =>params[:id])[0]
      ayah_relationship.known_value = params[:known_value]
      respond_to do |format|
        if ayah_relationship.save
          surah = Ayah.find(params[:current_aya_id]).surah
          known_of_surah = current_user.ayahs_knowns_per_surah surah.id
          format.json { render :json => known_of_surah }
        else
          format.json { render :json => false }
        end
      end
    end
  end

  def destroy
    if User.find(params[:id]) == current_user

    end
  end
end
