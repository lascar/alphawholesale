class TenderLinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tender_line, only: [:show, :edit, :update, :destroy]

  # GET /tender_lines
  def index
    authorize :tender_line, :index?
    tender = Tender.find_by_id(params[:tender_id])
    unless (customer_signed_in? && tender &&
            tender.customer_id == current_customer.id) ||
           broker_signed_in?
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
    @tender_lines = tender ? TenderLine.by_tender(params[:tender_id]) :
     TenderLine.by_approved(true)
  end

  # GET /tender_lines/1
  def show
    authorize @tender_line
    unless (customer_signed_in? &&
     current_customer.id == @tender_line.tender.customer_id) ||
     broker_signed_in?
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
    @customer_id = @tender_line.tender.customer_id
  end

  def products_for_new
    if customer_signed_in?
      current_customer.products.map{|p| [I18n.t('products.name.' + p.name), p.id]}
    else
      Product.all.pluck(:name, :id)
    end
  end

  def tenders_for_new
    if customer_signed_in?
      current_customer.tenders
    else
      Tender.all
    end
  end

  # GET /tender_lines/new
  def new
    tender = Tender.find_by_id tender_line_params[:tender_id]
    @products = products_for_new
    @tenders = tenders_for_new
    @customers = Customer.all.pluck(:identifier, :id) if broker_signed_in?
    @tender_line = TenderLine.new(tender_id: tender.id)
    authorize @tender_line
  end

  # GET /tender_lines/1/edit
  def edit
    authorize @tender_line
    if (customer_signed_in? &&
        current_customer.id == @tender_line.tender.customer_id) ||
       broker_signed_in?
      if broker_signed_in?
        @customers = Customer.all.pluck(:identifier, :id)
      end
      @customer_id = @tender_line.tender.customer_id
      @products = Product.all.pluck(:name, :id)
    else
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
  end

  # POST /tender_lines
  def create
    @customer_id = customer_signed_in? ? current_customer.id :
     params['customer_id']
    @tender_line = TenderLine.new(tender_line_params)
    authorize @tender_line
    tender = Tender.find_by_id(@tender_line.tender_id)
    if (customer_signed_in? && tender &&
        tender.customer_id == current_customer.id) || broker_signed_in?
      if @tender_line.save
        if customer_signed_in?
          redirect_to customer_tender_line_path(
           id: @tender_line.id, customer_id: @customer_id),
           notice: I18n.t('controllers.tender_lines.successfully_created')
        else
          redirect_to tender_line_path(@tender_line)
        end
      else
        @products = Product.all.pluck(:name, :id)
        render :new
      end
    else
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
  end

  # PATCH/PUT /tender_lines/1
  def update
    authorize @tender_line
    if (customer_signed_in? &&
        @tender_line.tender.customer_id == current_customer.id) ||
       broker_signed_in?
      if @tender_line.update(tender_line_params)
        if customer_signed_in?
          redirect_to customer_tender_line_path(
            @tender_line.tender.customer_id, @tender_line),
           notice: I18n.t('controllers.tender_lines.successfully_updated')
        else
          redirect_to tender_line_path(@tender_line),
           notice: I18n.t('controllers.tender_lines.successfully_updated')
        end
      else
        @tender_line = TenderLine.find(params[:id])
        @customer_id = @tender_line.tender.customer_id
        @products = Product.all.pluck(:name, :id)
        if broker_signed_in?
          @customers = Customer.all.pluck(:identifier, :id)
        end
        render :edit
      end
    else
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
  end

  # DELETE /tender_lines/1
  def destroy
    authorize @tender_line
    if (customer_signed_in? && current_customer.id == @tender_line.tender.customer_id) ||
     broker_signed_in?
      @tender_line.destroy
      if customer_signed_in?
        redirect_to customer_tender_lines_url(customer_id: current_customer.id),
          notice: I18n.t('controllers.tender_lines.successfully_destroyed')
      else
        redirect_to tender_lines_url,
          notice: I18n.t('controllers.tender_lines.successfully_destroyed')
      end
    else
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tender_line
      @tender_line = TenderLine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tender_line_params
      params.require(:tender_line).permit(:tender_id, :product_id, :variety_id,
                                          :aspect_id, :size, :packaging, :unit,
                                          :unit_price, :observation)
    end
end
