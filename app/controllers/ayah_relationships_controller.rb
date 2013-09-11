class AyahRelationshipsController < ApplicationController
  before_filter :authenticate_user!
  def create
    if User.find(params[:id]) == current_user
      ayah_relationship = current_user.ayah_relationships.build(:ayah_id => params[:current_aya_id], :known_value => params[:known_value])
      ayah_relationship.save
      result = true
    else
      result = false
    end
    respond_to do |format|
      format.json { render :json => result }
    end
  end

  def update

  end

  def destroy

  end
end
