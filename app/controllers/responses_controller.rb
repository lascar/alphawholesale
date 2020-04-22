class ResponsesController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_response, only: [:show, :edit, :update, :destroy]

  # GET /responses
  def index
    authorize :response, :index?
    @responses = Response.includes(request: [:concrete_product, :customer])
    if supplier_signed_in?
      @supplier_id = current_supplier.id
      @responses = @responses.where(supplier_id: @supplier_id)
    elsif customer_signed_in?
      @customer_id = current_customer.id
      @responses = @responses.where('requests.customer_id = ?', @customer_id)
    end
    unless params[:expired_too]
      @responses = @responses.not_expired
    end
  end

  # GET /responses/1
  def show
    authorize @response
    @supplier = @response.supplier
    @suppliers = [[@supplier.identifier, @supplier.id]]
    @request = @response.request
    @incoterms = [@response.incoterm]
  end

  # GET /responses/new
  def new
    @request = Request.find(params[:request_id])
    @supplier = current_supplier
    @suppliers = [[@supplier.identifier, @supplier.id]]
    @response = Response.new(supplier_id: @supplier.id, request_id: @request.id)
    authorize @response
    @incoterms = [INCOTERMS]
  end

  # GET /responses/1/edit
  def edit
    authorize @response
    @supplier = @response.supplier
    @suppliers = [[@supplier.identifier, @supplier.id]]
    @request = @response.request
    @incoterm = @response.incoterm
    @incoterms = INCOTERMS.map{|incoterm| [incoterm, incoterm]}
  end

  # POST /responses
  def create
    @response = Response.new(response_params)
    authorize @response
    @response.supplier_id = current_supplier.id
    if @response.save
      flash[:notice] = I18n.t('controllers.responses.successfully_created')
      redirect_to path_for(user: @user, path: 'response', options: {object_id: @response.id})
    else
      flash[:alert] = helper_activerecord_error_message('response', @response.errors.messages)
      redirect_to path_for(user: @user, path: 'new_response', options: {object_id: response_params[:request_id]})
    end
  end

  # PATCH/PUT /responses/1
  def update
    authorize @response
    if @response.update(response_params)
      flash[:notice] = I18n.t('controllers.responses.successfully_updated')
      redirect_to path_for(user: @user, path: 'response', options: {object_id: @response.id})
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
  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def response_params
    base = [:request_id, :quantity, :supplier_observation, :unit_price_supplier,
            :localisation_supplier, :incoterm]
    params.require(:response).permit(base)
  end

end
