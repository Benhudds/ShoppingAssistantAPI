class TescoapiController < ApplicationController
  @TescoForeignKey = 1
  
  # Method to add results to Tesco locations for the given query string
  def self.query(queryString)
    queries = Tescoquery.where(:query => queryString)
    
    # Check if there have been no queries
    if (queries.blank?)
      print "\n"
      print "\n"
      print "Queries blank"
      print "\n"
      print "\n"
      
      doQuery(queryString)
      # Check if the previous query is more than one day old
    elsif (queries.first.updated_at < 1.day.ago)
      print "\n"
      print "\n"
      print queries.first.updated_at < 1.day.ago
      print "\n"
      print "Query old"
      print "\n"
      print queries.first.updated_at.to_s
      print "\n"
      print 1.day.ago.to_s
      print "\n"
      print Time.now
      print "\n"
      print "\n"
      queries.first.updated_at = Time.now
      queries.first.save
      
      doQuery(queryString)
    end
  end
  
  # Method to perform a query on the Tesco API
  def self.doQuery(queryString)
    # Create the url
    urlpre = 'https://dev.tescolabs.com/grocery/products/?query='
    urlsuf = '&offset=0&limit=10'
    url = urlpre + queryString + urlsuf
    
    
    uri = URI(url)
    Net::HTTP::start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      
      request = Net::HTTP::Get.new uri
      request['Ocp-Apim-Subscription-Key'] = '5b39865ae93a463a8dea05a18b536f0f'
      @res = http.request request
    end
    
    # Get the json
    json = JSON.parse(@res.body)
    json = json['uk']
    json = json['ghs']
    json = json['products']
    
    addResults(json)
    
    Tescoquery.create!(:query => queryString)
  end
  
  # Method to delete the old ipls
  # Should be run once a day
  def self.perform
    oldIpls = Ipl.where(updated_at < 1.day.ago)
    
    oldIpls.each do |ipl|
      ipl.DELETE
    end
  end
  private

  #  Method to add the json results to the tesco foregin key location
  def self.addResults(json)
    json['results'].each do |ipl|
      dbIpl = Ipl.where(location_id: @TescoForeignKey, item: ipl['name']).first
      
      if (dbIpl == nil)
        Ipl.create!({:location_id => @TescoForeignKey,:item => ipl['name'], :quantity => ipl['ContentsQuantity'], :measure => ipl['ContentsMeasureType'], :price => ipl['price']})
        print "\n"
        print "\n"
        print "queing resque job"
        print "\n"
        print "\n"
        Resque.enqueue_at(1.days.from_now, TescoapiController)
      else
        dbIpl.update(:quantity => ipl['ContentsQuantity'], :measure => ipl['ContentsMeasureType'], :price => ipl['price'])
      end
    end
  end
  
end
