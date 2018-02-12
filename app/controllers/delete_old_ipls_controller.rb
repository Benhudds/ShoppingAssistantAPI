class DeleteOldIplsController < ApplicationController
  @queue = :delete
  
  def self.perform()
    TescoapiController.deleteOld
    IcelandwebController.deleteOld
  end
end
