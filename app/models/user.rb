class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :pins
  has_many :users
  has_many :follows, :dependent => :destroy
  has_many :followers, :class_name => 'Follow', :dependent => :destroy, :as => :followable
  has_many :followings, :through => :follows, :source => :followable, :source_type => 'User'

  acts_as_voter
  acts_as_votable

  after_create :send_welcome_email

	def self.from_omniauth(auth)
      sign_up = false
      user = where(provider2: auth.provider, uid2: auth.uid).first_or_create! do |user|
        user.provider2 = auth.provider
        user.uid2 = auth.uid
        user.email = auth.info.email
        user.name = auth.info.name
        user.image_file_name = auth.info.image
        user.password = Devise.friendly_token[0,20]
        sign_up = true
      end
      follow_fb_friends(auth, user) if sign_up
      user
  end

  def follow!(user, source=nil)
    follow = self.follows.new
    follow.followable = user
    follow.save!
  end

  def following?(follow)
    follow = self.follows.get_follow(follow)
    follow.size > 0 ? true : false
  end 

  def self.follow_fb_friends(auth, current_user)
    FacebookServices.new(auth).follow_user_friends(current_user)
  end

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/default.jpg"

  private
    def send_welcome_email
      ModelMailer.new_user_account_notification(self).deliver
    end
end
