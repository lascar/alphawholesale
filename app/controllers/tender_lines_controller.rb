class TenderLinesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission
  before_action :set_tender_line, only: [:show, :edit, :update, :destroy]

  # GET /tender_lines
  def index
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
    unless (customer_signed_in? &&
     current_customer.id == @tender_line.tender.customer_id) ||
     broker_signed_in?
      redirect_to "/customers/" + current_customer.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
    @customer_id = @tender_line.tender.customer_id
  end

  # GET /tender_lines/new
  def new
    t = Tender.find_by_id tender_line_params[:tender_id]
    if customer_signed_in?
      @products = current_customer.products.
       map{|p| [I18n.t('products.name.' + p.name), p.id]}
      @tenders = current_customer.tenders
      tender = (t && t.customer_id == current_customer.id) ? t : nil
    else
      customer = Customer.find_by_id params['customer_id']
      @products = Product.all.pluck(:name, :id)
      @customers = Customer.all.pluck(:identifier, :id)
      @tenders = Tender.all
      tender = t
    end
    @currencies = CURRENCIES.map do |currency|
      [I18n.t('currencies.' + currency + '.currency') +
       ' (' + I18n.t('currencies.' + currency + '.symbol') + ')',
       currency]
    end
    @unit_types = UNIT_TYPES.map do |unit_type|
      [I18n.t('unit_types.' + unit_type + '.unit_type') +
       ' (' + I18n.t('unit_types.' + unit_type + '.symbol') + ')',
       unit_type]
    end
    @tender_line = TenderLine.new(tender_id: (tender ? tender.id : nil))
  end

  # GET /tender_lines/1/edit
  def edit
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
                                          :unit_type, :unit_price, :currency,
                                          :observation)
    end
end
