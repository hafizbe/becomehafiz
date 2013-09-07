class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :ayah_relationships_attributes
  # attr_accessible :title, :body

  before_save :reset_authentication_token
  has_many :ayah_relationships
  has_many :ayahs, :through => :ayah_relationships
  accepts_nested_attributes_for :ayah_relationships

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  def ayahs_known(surah_id)
   self.ayahs.where("surah_id = ?",surah_id).order("position")
  end
end
