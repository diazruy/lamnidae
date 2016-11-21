class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :integration_keys_attributes
  # attr_accessible :title, :body

  has_many :integration_keys, uniq: :source, dependent: :destroy do
    def insightly
      find_by_source(:insightly).try :key
    end
  end

  accepts_nested_attributes_for :integration_keys
end
