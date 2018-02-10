class DeleteOldIplsController < ApplicationController
  @queue = :delete
  
  def self.perform()
    IcelandwebController.deleteOld
    TescoapiController.deleteOld
  end
end
