class BrokersController < ApplicationController
  include BrokersHelper
  before_action :authenticate_user!
  before_action :verify_permission_user
  before_action :set_broker, only: [:show, :edit, :update, :destroy]

  # GET /brokers
  def index
    @brokers = Broker.all
  end

  # GET /brokers/1
  def show
    @suppliers_without_approved = Supplier.with_approved(false)
    @customers_without_approved = Customer.with_approved(false)
    @products_without_approved = Product.with_approved(false)
    @offers_without_approved = Offer.with_approved(false)
    @tenders_without_approved = Tender.with_approved(false)
    @orders_without_approved = Order.with_approved(false)
    @packagings_without_approved = Packaging.with_approved(false)
  end

  # GET /brokers/new
  def new
    @broker = Broker.new
  end

  # GET /brokers/1/edit
  def edit
  end

  # POST /brokers
  def create
    @broker = Broker.new(broker_params)

    if @broker.save
      redirect_to @broker, notice: I18n.t('controllers.brokers.successfully_created')
    else
      flash[:alert] = helper_activerecord_error_message('broker',
                                                  @broker.errors.messages)
      redirect_to broker_new_path
    end
  end

  # PATCH/PUT /brokers/1
  def update
    if @broker.update(broker_params)
      redirect_to @broker, notice: I18n.t('controllers.brokers.successfully_updated')
    else
      flash[:alert] = helper_activerecord_error_message('broker',
                                                  @broker.errors.messages)
      redirect_to broker_edit_path
    end
  end

  # DELETE /brokers/1
  def destroy
    @broker.destroy
    redirect_to brokers_url, notice: I18n.t('controllers.brokers.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_broker
      @broker = Broker.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def broker_params
      params.require(:broker).permit(:identifier, :local, :email, :password, :password_confirmation)
    end
end
