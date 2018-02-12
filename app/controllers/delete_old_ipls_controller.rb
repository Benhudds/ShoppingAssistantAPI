class DeleteOldIplsController < ApplicationController
  @queue = :delete
  
  def self.perform()
    print "\n"
    print "\n"
    print "resque"
    print "\n"
    print "\n"
    TescoapiController.deleteOld
  end
end
