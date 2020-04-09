class Supplier < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :offers
  has_many :user_concrete_products, as: :user, dependent: :delete_all
  has_many :concrete_products, through: :user_concrete_products
  has_many :user_products, as: :user, dependent: :delete_all
  has_many :products, through: :user_products
  validates :identifier, presence: true, allow_blank: false, uniqueness: true
  validates :email, presence: true, allow_blank: false
  validates :tin, presence: true, allow_blank: false
  validates :country, presence: true, allow_blank: false
  validates :entreprise_name, presence: true, allow_blank: false
  validates :password, presence: true, allow_blank: false,
   length: {minimum: 6}, on: :create
  after_commit :send_welcome_mail_if_approved

  def self.with_approved(approved)
    where(approved: approved)
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  private
  def send_welcome_mail_if_approved
    if previous_changes["approved"] == [false, true]
      SendUserApprovalJob.perform_later(self)
    end
  end
end
