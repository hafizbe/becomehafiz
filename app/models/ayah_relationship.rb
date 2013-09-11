class AyahRelationship < ActiveRecord::Base
  attr_accessible :ayah_id, :integer, :known_value
  belongs_to :ayah
  belongs_to :user
end
