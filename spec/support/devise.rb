# spec/support/devise.rb

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

def sign_in_user( user_type_sym=:supplier )
  @user = FactoryBot.build(user_type_sym)
  # @user.skip_confirmation!
  @user.save!
  byebug
  sign_in @user
end
