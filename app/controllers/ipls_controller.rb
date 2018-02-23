class IplsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_location
  before_action :set_location_ipl, only: [:show, :update, :destroy]

  # GET /locations/:location_id/ipls
  def index
    
    # Check if this is a Tesco location
    if ((@location.name.include? TescoapiController.getName) && @location.id != TescoapiController.getForeignKey)
      
      ipls = Ipl.where(location_id: TescoapiController.getForeignKey)
      @location.ipls.each do |ipl|
        ipls = ipls + Array.new(1).push(ipl)
      end
      
      json_response(ipls)
      
      # Check if this is an Iceland location
    elsif ((@location.name.include? IcelandwebController.getName) && @location.id != IcelandwebController.getForeignKey)
    
      ipls = Ipl.where(location_id: IcelandwebController.getForeignKey)
      @location.ipls.each do |ipl|
        ipls = ipls + Array.new(1).push(ipl)
      end
      
      json_response(ipls)
      
      # Otherwise return ipls normally
    else
      json_response(@location.ipls)
    end
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
    params.permit(:item, :price, :quantity, :measure, :imageurl)
  end
  
  def set_location
    @location = Location.find(params[:location_id])
  end
  
  def set_location_ipl
    @ipl = @location.ipls.find_by!(id: params[:id]) if @location
  end
end
