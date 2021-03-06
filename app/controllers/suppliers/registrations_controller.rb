# frozen_string_literal: true

class Suppliers::RegistrationsController < Devise::RegistrationsController
  include Utilities
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if supplier_signed_in? or customer_signed_in?
      raise Pundit::NotAuthorizedError
    end
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # POST /resource
  def create
    if supplier_signed_in? or customer_signed_in?
      raise Pundit::NotAuthorizedError
    end
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # GET /resource/edit
  def edit
    if !current_supplier.id == params[:id] or !broker_signed_in?
      raise Pundit::NotAuthorizedError
    end
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # PUT /resource
  def update
    if !current_supplier.id == params[:id] or !broker_signed_in?
      raise Pundit::NotAuthorizedError
    end
    @currencies, @unit_types = put_currencies_unit_types
    super
  end

  # DELETE /resource
  def destroy
    if !broker_signed_in?
      raise Pundit::NotAuthorizedError
    end
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

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    if broker_signed_in? and action_name == 'destroy'
      redirect_to '/suppliers/', alert: I18n.t(
        'controllers.suppliers_registrations.action_not_allowed_from_here')
      return
    end
    if customer_signed_in?
      flash.alert = I18n.t('devise.errors.messages.not_authorized')
      redirect_to '/customers/' + current_customer.id.to_s
      return
    end
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

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
                              :password, :password_confirmation,
                              :current_password])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  def after_update_path_for(resource)
    supplier_path(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    if broker_signed_in?
      flash.notice = I18n.t('controllers.suppliers.successfully_created')
      return
    else
      super(resource)
    end
  end

end
