class AyahRelationship < ActiveRecord::Base
  attr_accessible :ayah_id, :known_value
  belongs_to :ayah
  belongs_to :user
end
