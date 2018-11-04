class Broker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :identifier, presence: true, allow_blank: false, uniqueness: true
  validates :email, presence: true, allow_blank: false
  validates :password, presence: true, allow_blank: false, length: {minimum: 6}
end
