class DeleteOldIplsController < ApplicationController
  @queue = :delete
  
  def self.perform()
    
    # Delete the old ipls
    TescoapiController.deleteOld
    IcelandwebController.deleteOld
  end
end
