class AyahRelationshipsController < ApplicationController
  before_filter :authenticate_user!
  def create
    if User.find(params[:id]) == current_user
      ayah_relationship = current_user.ayah_relationships.build(:ayah_id => params[:current_aya_id], :known_value => params[:known_value])
    end
    respond_to do |format|
      format.json { render :json => ayah_relationship.save }
    end
  end

  def update
    if User.find(params[:id]) == current_user
      ayah_relationship =  AyahRelationship.where(:ayah_id => params[:current_aya_id], :user_id =>params[:id])[0]
      ayah_relationship.known_value = params[:known_value]
      if ayah_relationship.save
        known_of_surah = current_user.ayahs_knowns_per_surah 1
        respond_to do |format|
          format.json { render :json => true }
        end

      end


    end

  end

  def destroy

  end
end
