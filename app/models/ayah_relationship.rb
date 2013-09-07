class AyahRelationship < ActiveRecord::Base
  attr_accessible :ayah_id, :integer, :known_value, :user_id
  belongs_to :ayah
  belongs_to :user
end
