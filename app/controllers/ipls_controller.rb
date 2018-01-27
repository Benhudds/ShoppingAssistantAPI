class IplsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_location
  before_action :set_location_ipl, only: [:show, :update, :destroy]

  
  # GET /locations/:location_id/ipls
  def index
    if (@location.name.include? "Tesco" )
      @TescoForeignKey = 1
      ipls = Ipl.where(location_id: @TescoForeignKey)
      print "\n"
      print "\n"
      print "returning tesco ipls"
      print "\n"
      print ipls.count 
      print "\n"
      print @location.ipls.count
      print "\n"
      print ipls
      print "\n"
      print "\n"
      @location.ipls.each do |ipl|
        ipls = ipls + Array.new(1).push(ipl)
      end
      
      json_response(ipls)
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
    params.permit(:item, :price, :quantity, :measure)
  end
  
  def set_location
    @location = Location.find(params[:location_id])
  end
  
  def set_location_ipl
    @ipl = @location.ipls.find_by!(id: params[:id]) if @location
  end
end
