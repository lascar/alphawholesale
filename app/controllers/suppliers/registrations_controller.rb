# frozen_string_literal: true

class Suppliers::RegistrationsController < Devise::RegistrationsController
  include Accessible
  skip_before_action :check_user, except: [:new, :create]
  before_action :verify_permission_user
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # POST /resource
  def create
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [:identifier, :email, :email, :entreprise_name,
                       :tin, :street_and_number, :postal_code,
                       :city, :state, :country, :currency, :unit_type,
                       :telephone_number1, :telephone_number2,
                       :password, :password_confirmation])
    if broker_signed_in?
      devise_parameter_sanitizer.permit(:sign_up, keys: [:approved])
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:identifier, :email, :entreprise_name,
                              :tin, :street_and_number, :postal_code,
                              :city, :state, :country, :currency, :unit_type,
                              :telephone_number1, :telephone_number2,
                              :password, :password_confirmation, :approved])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if broker_signed_in?
      flash.notice = I18n.t('controllers.suppliers.successfully_created')
      return
    else
      super(resource)
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    if broker_signed_in?
      return
    else
      super(resource)
    end
  end

  def put_currencies_unit_types
    currencies = CURRENCIES.map do |currency|
      [I18n.t('currencies.' + currency + '.currency') +
       ' (' + I18n.t('currencies.' + currency + '.symbol') + ')',
       currency]
    end
    unit_types = UNIT_TYPES.map do |unit_type|
      [I18n.t('unit_types.' + unit_type + '.unit_type') +
       ' (' + I18n.t('unit_types.' + unit_type + '.symbol') + ')',
       unit_type]
    end
    return [currencies, unit_types]
  end
end
