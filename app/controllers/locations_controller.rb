require 'net/http'
class LocationsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_location, only: [:show, :update, :destroy]
  
  # GET /locations
  def index
    
    # If the user supplies a latitude and longitude value
    if (params[:lat] != nil && params[:lng] != nil)
      
      locationQueries = Locationquery.where(lat: params[:lat].to_f.round(4), lng: params[:lng].to_f.round(4))
      
      if locationQueries.blank?()
          # Arbitrary constant of 2.5km, this is about how far I am willing to travel to go grocery shopping
          # was used to calculate these values. See logbook for more details
          latdivisor = 44.2296
          lngdivisor = 44.528
          
          # 1/latdivisor
          # 1/lngdivisor
          latvariance = 1 / latdivisor
          lngvariance = 1 / (Math.cos(params[:lat].to_f) * lngdivisor)
          
          latlower = params[:lat].to_f - latvariance
          latupper = params[:lat].to_f + latvariance
          
          
          # Order passed to between matters so we must assure the lowest value is passed into the query first
          if (params[:lng].to_f < 0)
            lnglower = params[:lng].to_f + lngvariance
            lngupper = params[:lng].to_f - lngvariance
          else
            lnglower = params[:lng].to_f - lngvariance
            lngupper = params[:lng].to_f + lngvariance
          end
        
        
        # If we have not searched for this location, check if there are any nearby locations that have already been searched
        if (Locationquery.where(lat: latlower..latupper,lng: lnglower..lngupper).blank?())
        # Do a new search
        @locations = queryLocation
        
        lat = params[:lat].to_f.round(4)
        lng = params[:lng].to_f.round(4)
        Locationquery.create!(:lat => lat, :lng => lng)
        else
          getLocationsIn5km
        end
      elsif locationQueries.first().updated_at < 1.month.ago
        # Otherwise do a new query if the old one needs refreshing
        @locations = queryLocation
        locationQueries.first().updated_at = Time.now
      else
        getLocationsIn5km
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
  
  def getLocationsIn5km
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
    
    # Return the list of locations within the valid latitude and longitude ranges
    @locations = Location.where(lat: @latlower..@latupper, lng: @lnglower..@lngupper)
  end
  
  def queryLocation
    @urlpre = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location='
    @urlsuf = '&radius=5000&type=grocery_or_supermarket&key='
    @apikey = 'AIzaSyBZNkl0tUTymbtbp7zwL0sv-9zBw0ba5-s'
    @url = @urlpre + params[:lat] + "," + params[:lng] + @urlsuf + @apikey
    
    @locations = Array.new
    
    loop do
      # Get the Google API JSON response
      @uri = URI(@url)
      @response = Net::HTTP.get(@uri)
      @parsed = JSON.parse(@response)
      
      pageToken = @parsed['next_page_token']
      
      # Create new locations for all those retrieved from the Google API and add them to a return list
      @parsed['results'].each do |location|
        if (Location.where(googleid: location['id']).blank?)
          @locations = @locations + Array.new(1).push(Location.create!({:name => location['name'], :lat => location['geometry']['location']['lat'], :lng => location['geometry']['location']['lng'], :vicinity =>location['vicinity'], :googleid => location['id']}))
        end
      end
      
      if pageToken == nil
        break
      end
      
      @url = @urlpre + params[:lat] + "," + params[:lng] + @urlsuf + @apikey + "&pagetoken=" + pageToken
      break if pageToken == nil or pageToken == ''
    end
    
    return @locations
  end
  
  def location_params
    params.permit(:name, :lat, :lng, :vicinity, :googleid)
  end
  
  def set_location
    @location = Location.find(params[:id])
  end
end
