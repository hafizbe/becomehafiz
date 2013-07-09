class Api::V1::AmazonController < ApplicationController
  include Amazon
  def get_url
    id_surah  = count_number params[:surah]
    s3 = AWS::S3.new
    surah_mp3 = s3.buckets['hafizbe'].objects["#{params[:recitator]}/#{params[:surah]}/#{params[:surah]}-#{params[:num_fichier]}.mp3"]
    surah_xml = s3.buckets['hafizbe'].objects["#{params[:recitator]}/#{params[:surah]}/#{params[:surah]}-#{params[:num_fichier]}.xml"]
    @surah = Array.new
    @surah << surah_mp3.url_for(:read, :secure => true)
    @surah << surah_xml.url_for(:read, :secure => true)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @surah.to_json }
    end
  end
end