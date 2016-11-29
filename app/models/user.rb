class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :photos
  has_many :subscriptions

  validates :name, presence: true 
  validates :lang, presence: true #, acceptance: { accept: ['en', 'ru'] } 


  def is_friend?(other_user)
  	if self.subscriptions.find_by(friend_id: other_user).nil?
  		false
  	else 
  		true
  	end
  end

end
