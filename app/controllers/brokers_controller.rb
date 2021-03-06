class BrokersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_broker, only: [:show, :edit, :update, :destroy]

  # GET /brokers
  def index
    authorize :broker, :index?
    @brokers = Broker.all
  end

  # GET /brokers/1
  def show
    authorize @broker
    @suppliers_without_approved = Supplier.with_approved(false)
    @customers_without_approved = Customer.with_approved(false)
    @offers_without_approved = Offer.where(approved: false).not_expired
    @orders_without_approved = Order.where(approved: false).not_expired
    @requests_without_approved = Request.where(approved: false).not_expired
    @responses_without_approved = Response.where(approved: false).not_expired
  end

  # GET /brokers/new
  def new
    @broker = Broker.new
    authorize @broker
  end

  # GET /brokers/1/edit
  def edit
    authorize @broker
  end

  # POST /brokers
  def create
    @broker = Broker.new(broker_params)
    authorize @broker

    if @broker.save
      redirect_to @broker, notice: I18n.t('controllers.brokers.successfully_created')
    else
      flash[:alert] = helper_activerecord_error_message('broker',
                                                  @broker.errors.messages)
      redirect_to path_for(user: @user, path: 'new_broker')
    end
  end

  # PATCH/PUT /brokers/1
  def update
    authorize @broker
    if @broker.update(broker_params)
      redirect_to @broker, notice: I18n.t('controllers.brokers.successfully_updated')
    else
      flash[:alert] = helper_activerecord_error_message('broker',
                                                  @broker.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_broker', options: {object_id: @broker.id})
    end
  end

  # DELETE /brokers/1
  def destroy
    authorize @broker
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
