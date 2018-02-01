class IcelandwebController < ApplicationController
  @IcelandForeignKey = 21
  
  # Method to add results to Asda locations for the given query string
  def self.query(queryString)
    queries = Icelandquery.where(:query => queryString)
    
    #Check if there have been no queries
    if (queries.blank?)
      
      doQuery(queryString)
    elsif (queries.first.updated_at < 1.day.ago)
      queries.first.updated_at = Time.now
      queries.first.save
      
      doQuery(queryString)
    end
  end
  
  # Method to perform a query on the ASDA web page
  def self.doQuery(queryString)
    # Create the url
    #urlpre = 'http://groceries.iceland.co.uk/search?w='
    #urlmid = '&ref=groceries.iceland.co.uk%2F&'
    urlpre = 'http://iceland.resultspage.com/search?w='
    urlsuf = '&p=Q&cnt=40&ts=json-full&ua=Mozilla/5.0%20(Windows%20NT%2010.0;%20Win64;%20x64)%20AppleWebKit/537.36%20(KHTML,%20like%20Gecko)%20Chrome/63.0.3239.132%20Safari/537.36&cip=127.0.0.1&ref=groceries.iceland.co.uk%2F&isort=score&filter=storeid:0%20days_from_now:1&callback=searchResponse&_=1517415377803'
    url = urlpre + queryString + urlsuf# + queryString
    
    uri = URI(url)
    Net::HTTP::start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      
      request = Net::HTTP::Get.new uri
      @res = http.request request
    end

    # Remove the start and end substrings
    content = @res.body[15..-2]
    json = JSON.parse(content)
    addResults(json)
    
    Icelandquery.create!(:query => queryString)
  end
  
  #Method to delete the old ipls
  def self.deleteOld
    oldIpls = Ipl.where(location_id: @IcelandForeignKey).where(updated_at < 1.day.ago)
    
    oldIpls.each do |ipl|
      ipl.DELETE
      ipl.save
    end
  end
  
  private
  
    #  Method to add the json results to the iceland foregin key location
  def self.addResults(json)
    json['results'].each do |ipl|
      
      dbIpl = Ipl.where(location_id: @IcelandForeignKey, item: ipl['title']).first

      parts = ipl['unitPrice'].split(' ')
      priceStr = parts[0]
      
      if (priceStr.include? '£')
        price = priceStr[1..0].to_i
      elsif (priceStr.include? 'p')
        price = priceStr[0..-1].to_i
      end
      
      if (dbIpl == nil)
        Ipl.create!({:location_id => @IcelandForeignKey,:item => ipl['title'], :quantity => parts[2], :measure => parts[3], :price => price})
      else
        dbIpl.update(:quantity => parts[2], :measure => parts[3], :price => price)
      end
    end
  end
end
