class Broker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable
  validates :identifier, presence: true, allow_blank: false, uniqueness: true
  validates :email, presence: true, allow_blank: false
  validates :password, presence: true, allow_blank: false, length: {minimum: 6}
  has_many :attached_products, as: :attachable, dependent: :delete_all
end
