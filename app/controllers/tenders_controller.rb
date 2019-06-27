class TendersController < ApplicationController
  include TendersHelper
  before_action :authenticate_user!
  before_action :set_tender, only: [:show, :edit, :update, :destroy]

  # GET /tenders
  def index
    authorize :tender, :index?
    if current_broker
      @tenders = Tender.with_approved(true)
     else
      @customer_id = current_customer.id
      @tenders = Tender.where(customer_id: @customer_id)
    end
  end

  # GET /tenders/1
  def show
    authorize @tender
    @customer_id = customer_signed_in? ? current_customer.id : params[:customer_id]
    @tender_lines = @tender.tender_lines
  end

  # GET /tenders/new
  def new
    @customer_id = customer_signed_in? ? current_customer.id :
     params['customer_id']
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @tender = Tender.new(customer_id: @customer_id)
    authorize @tender
  end

  # GET /tenders/1/edit
  def edit
    authorize @tender
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @customer_id = @tender.customer_id
    @tender.customer_id = @customer_id
  end

  # POST /tenders
  def create
    @tender = Tender.new(tender_params)
    authorize @tender
    @customer_id = customer_signed_in? ? current_customer.id : tender_params['customer_id']
    @tender.customer_id = @customer_id
    if @tender.save
      if customer_signed_in?
        redirect_to customer_tender_path(id: @tender.id, customer_id: @customer_id), notice: I18n.t('controllers.tenders.successfully_created')
      else
        redirect_to tender_path(@tender)
      end
    else
      render :new
    end
  end

  # PATCH/PUT /tenders/1
  def update
    authorize @tender
    if @tender.update(tender_params)
      redirect_to tender_show_path(@tender), notice: I18n.t('controllers.tenders.successfully_updated')
    else
      @tender = Tender.find(params[:id])
      if broker_signed_in?
        @customers = Customer.all.pluck(:identifier, :id)
      end
      render :edit
    end
  end

  # DELETE /tenders/1
  def destroy
    authorize @tender
    @tender.destroy
    redirect_to tenders_index_path,
      notice: I18n.t('controllers.tenders.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tender
      @tender = Tender.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tender_params
      params.require(:tender).permit(:customer_id, :date_start, :date_end)
    end
end
