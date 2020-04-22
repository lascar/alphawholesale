class BrokerResponsesController < ApplicationController
  before_action :set_context_prefixe, except: [:create, :update, :destroy]
  before_action :set_response, only: [:show, :edit, :update, :destroy]

  # GET /responses
  def index
    lookup_context.prefixes << 'responses'
    @customer_id = params[:customer_id]
    @supplier_id = params[:supplier_id]
    @responses = Response.includes(:request)
    if @customer_id
      @responses = @response.where(customer_id: @customer_id)
    end
    if @supplier_id
      @responses = @responses.joins(:request).where('requests.supplier_id = ?', @supplier_id)
    end
    unless params[:not_approved_too]
      @responses = @responses.where(approved: true)
    end
    unless params[:expired_too]
      @responses = @responses.not_expired
    end
  end

  # GET /responses/1
  def show
    lookup_context.prefixes << 'responses'
    authorize @response
    @supplier = @response.supplier
    @suppliers = [[@supplier.identifier, @supplier.id]]
    @request = @response.request
    @incoterms = [@response.incoterm]
  end

  # GET /responses/new
  def new
    supplier_id = params[:supplier_id]
    @request = Request.find(params[:request_id])
    @supplier = Supplier.find_by(id: supplier_id) || Supplier.first
    @response = Response.new(supplier_id: supplier_id, request_id: @request.id)
    authorize @response
    @suppliers = Supplier.all.pluck(:identifier, :id)
    @incoterms = [INCOTERMS]
  end

  # GET /responses/1/edit
  def edit
    authorize @response
    @suppliers = Customer.all.pluck(:identifier, :id)
    @supplier = @response.supplier
    @request = @response.request
    @incoterms = [INCOTERMS]
  end

  # POST /responses
  def create
    @response = Response.new(response_params)
    if @response.save
      flash[:notice] = I18n.t('controllers.responses.successfully_created')
      redirect_to path_for(path: 'response', options: {object_id: @response.id})
      return
    else
      flash[:alert] = helper_activerecord_error_message('response', @response.errors.messages)
      redirect_to path_for(path: 'new_response', options: {object_id: response_params[:offer_id]})
    end
  end

  # PATCH/PUT /responses/1
  def update
    if @response.update(response_params)
      flash[:notice] = I18n.t('controllers.responses.successfully_updated')
      redirect_to path_for(path: 'response', options: {object_id: @response.id})
      return
    else
      flash[:alert] = helper_activerecord_error_message('response', @response.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_response', options: {object_id: @response.id})
    end
  end

  # DELETE /responses/1
  def destroy
    authorize @response
    @response.destroy
    flash[:notice] = I18n.t('controllers.responses.successfully_destroyed')
    redirect_to path_for(user: @user, path: 'responses')
  end

  private
  def set_context_prefixe
    lookup_context.prefixes << 'responses'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def response_params
    base = [:supplier_id, :request_id, :quantity, :supplier_observation,
            :unit_price_supplier, :unit_price_broker, :localisation_supplier,
            :localisation_broker, :incoterm, :approved]
    params.require(:response).permit(base)
  end

end
