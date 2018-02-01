class AsdawebController < ApplicationController
  @AsdaForeignKey = 2
  
  # Method to add results to Asda locations for the given query string
  def self.query(queryString)
    queries = Asdaquery.where(:query => queryString)
    
    #Check if there have been no queries
    if (queries.blank?)
      
      doQuery(queryString)
    elsif (queries.first.updated_at < 1.day.ago)
      queries.first.updated_at = Time.now
      queries.first.save
      
      doQuery(queryString)
    end
  end
  
    def self.fetch(uri_str, limit = 10)
  # You should choose better exception.
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    print "\n"
    print uri_str
    print "\n"
  url = URI.parse(uri_str)
  req = Net::HTTP::Get.new(url.path, { 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'})
  response =     Net::HTTP::start(url.host, url.port,
      :use_ssl => url.scheme == 'https') do |http|

    http.request(req)
  end
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then fetch(response['location'], limit - 1)
  else
    response.error!
  end
  
  return response
end
  
  # Method to perform a query on the ASDA web page
  def self.doQuery(queryString)
    # Create the url
    urlpre = 'https://groceries.asda.com/search/'
    urlmid = '?cmpid=ahc-_-ghs-_-asdacom-_-hp-_-search-'
    url = urlpre + queryString + urlmid + queryString
    
    @res = fetch(url)
    
    print "\n"
    print "\n"
    print "\n"
    print @res.body
    print "\n"
    
    if (@res.body.include? "listings")
      print "true"
      print "\n"
    else
      print "false"
      print "\n"
    end
    if(@res.body.include? "Sorry")
      print "Sanity check"
      print "\n"
    end
    print queryString
    print "\n"
    print url
    print "\n"
    print @res
    print "\n"
    print "\n"
  end
  
  #Method to delete the old ipls
  def self.deleteOld
    oldIpls = Ipl.where(location_id: @AsdaForeignKey).where(updated_at < 1.day.ago)
    
    oldIpls.each do |ipl|
      ipl.DELETE
      ipl.save
    end
  end
end
