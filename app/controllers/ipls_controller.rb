class IplsController < ApplicationController
  before_action :set_location
  before_action :set_location_ipl, only: [:show, :update, :destroy]
  
  # GET /locations/:location_id/ipls
  def index
    json_response(@location.ipls)
  end
  
  # GET /locations/:location_id/ipls/:id
  def show
    json_response(@ipl)
  end
  
  # POST /locations/:location_id/ipls
  def create
    @location.ipls.create!(ipl_params)
    json_response(@location, :created)
  end
  
  # PUT /locations/:location_id/ipls/:id
  def update
    @ipl.update(ipl_params)
    head :no_content
  end
  
  # DELETE /locations/:location_id/ipls/:id
  def destroy
    @ipl.destroy
    head :no_content
  end
  
  private
  
  def ipl_params
    params.permit(:name, :price)
  end
  
  def set_location
    @location = Location.find(params[:location_id])
  end
  
  def set_location_ipl
    @ipl = @location.ipls.find_by!(id: params[:id]) if @location
  end
end
