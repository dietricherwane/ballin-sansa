class User < ActiveRecord::Base
  belongs_to :profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
 :remember_me, :firstname, :lastname, :phone_number, :mobile_number, :published, :profile_id, :confirmation_token, :authentication_token
	
	# Validations
	validates :firstname, :lastname, :phone_number, :mobile_number, :profile_id, :presence => true
	#validates :firstname, :lastname, :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
	validates :phone_number, :mobile_number, :numericality => { :only_integer => true }
	#validates :firstname, :lastname, :phone_number, :mobile_number, :length => { :minimum => 2 }
	#validates :phone_number, :mobile_number, :length => { :is => 8 }
	
	def short_profile
		"#{Profile.find_by_id(profile_id).shortcut}"
	end
	
	def full_name
	  "#{lastname} #{firstname}"
	end
	
	def profile_name
	  "#{Profile.find_by_id(profile_id).name}"
	end
	
	def enabled?
	  published.eql?(true)
	end
	
	def pending?
	  !confirmation_token.blank?
	end
	
end
