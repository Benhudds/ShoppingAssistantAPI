require 'net/http'
class LocationsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_location, only: [:show, :update, :destroy]
  
  # GET /locations
  def index
    
    # If the user supplies a latitude and longitude value
    if (params[:lat] != nil && params[:lng] != nil)
      # Arbitrary constant of 5km, this is about how far I am willing to travel to go grocery shopping
      # was used to calculate these values. See logbook for more details
      @latdivisor = 22.1148
      @lngdivisor = 22.264
      
      # 1/latdivisor
      # 1/lngdivisor
      @latvariance = 1 / @latdivisor
      @lngvariance = 1 / (Math.cos(params[:lat].to_f) * @lngdivisor)
      
      @latlower = params[:lat].to_f - @latvariance
      @latupper = params[:lat].to_f + @latvariance
      
      
      # Order passed to between matters so we must assure the lowest value is passed into the query first
      if (params[:lng].to_f < 0)
        @lnglower = params[:lng].to_f + @lngvariance
        @lngupper = params[:lng].to_f - @lngvariance
      else
        @lnglower = params[:lng].to_f - @lngvariance
        @lngupper = params[:lng].to_f + @lngvariance
      end
      
      print "\n"
      print "lat = " + params[:lat].to_s + "\n"
      print "lng = " + params[:lng].to_s + "\n"
      print "latlower = " + @latlower.to_s + "\n"
      print "latupper = " + @latupper.to_s + "\n"
      
      print "lnglower = " + @lnglower.to_s + "\n"
      print "lngupper = " + @lngupper.to_s + "\n"
      print "\n"
      
      # Return the list of locations within the valid latitude and longitude ranges
      @locations = Location.where(lat: @latlower..@latupper, lng: @lnglower..@lngupper)
      
      # If there are no locations in the database we want to go to the Google Places API and find nearby locations
      # API Key = AIzaSyBZNkl0tUTymbtbp7zwL0sv-9zBw0ba5-s
      if (!@locations.any?)
        @urlpre = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location='
        @urlsuf = '&radius=5000&type=grocery_or_supermarket&key='
        @apikey = 'AIzaSyBZNkl0tUTymbtbp7zwL0sv-9zBw0ba5-s'
        
        @url = @urlpre + params[:lat] + "," + params[:lng] + @urlsuf + @apikey
        
        # Get the Google API JSON response
        @uri = URI(@url)
        @response = Net::HTTP.get(@uri)
        @parsed = JSON.parse(@response)
        
        # Create new locations for all those retrieved from the Google API and add them to a return list
        @locations = Array.new
        @parsed['results'].each do |location|
          if (Location.where(id: location['id']).blank?)
            @locations = @locations + Array.new(1).push(Location.create!({:name => location['name'], :lat => location['geometry']['location']['lat'], :lng => location['geometry']['location']['lng'], :vicinity =>location['vicinity'], :googleid => location['id']}))
          end
        end
      end
    else
      @locations = Location.all
    end
    
    json_response(@locations)
  end
  
  # POST /locations
  def create
    @location = Location.create!(location_params)
    json_response(@location, :created)
  end
  
  # GET /locations/:id
  def show
    json_response(@location)
  end
  
  # PUT /locations/:id
  def update
    @location.update(location_params)
    head :no_content
  end
  
  # DELETE /locations/:id
  def destroy
    @location.destroy
    head :no_content
  end
  
  private
  
  def location_params
    params.permit(:name, :lat, :lng, :vicinity, :googleid)
  end
  
  def set_location
    @location = Location.find(params[:id])
  end
end
