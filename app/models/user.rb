class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :ayah_relationships_attributes, :ayahs_attributes
  # attr_accessible :title, :body

  before_save :reset_authentication_token
  has_many :ayah_relationships
  has_many :ayahs, :through => :ayah_relationships,
        :select => "ayahs.*, ayah_relationships.known_value"

  accepts_nested_attributes_for :ayah_relationships

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  def ayahs_known(surah_id)
   self.ayahs.where("surah_id = ?",surah_id).order("position")
  end

  def ayahs_knowns_per_surah(surah_id)
    nb_point_total = Surah.find(surah_id).nb_versets.to_f * 3

    ((self.ayahs.where(:surah_id => surah_id).size.to_f / Surah.find(surah_id).nb_versets.to_f) * 100).round 2
  end

  def ayahs_knowns_for_quran
    (self.ayahs.count.to_f / 6236  * 100).round 2
  end

  def get_ayah_with_known_classe(surah_id)

    range = self.ayahs.where(:surah_id => surah_id).map(&:id).join(' ,')
    ayah_relationships = nil
    unless range.empty?
      ayah_relationships = self.ayah_relationships.where("ayah_id IN (#{range}) ")
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
      word = "bad"
    else if number == 2
           word = "good"
         else if number == 3
                word = "very_good"
              end
         end
    end
  end
end
