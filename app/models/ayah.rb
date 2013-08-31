class Ayah < ActiveRecord::Base
  attr_accessible :position, :surah_id
  belongs_to :surah
end
