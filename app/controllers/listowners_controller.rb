class ListownersController < ApplicationController
  before_action :set_listowner, only: [:show, :update, :destroy]
  
  # GET /listowners
  def index
    @listowners = Listowner.all
    json_response(@listowners)
  end
  
  # POST /listowners
  def creates
    @listowner = Listowner.create!(listowner_params)
    json_response(@listowner, :created)
  end
  
  # GET /listowners/:id
  def show 
    json_response(@listowner)
  end
  
  # PUT /listowners/:id
  def update
    @listowner.update(listowner_params)
    head :no_content
  end
  
  # DELETE /listowners/:id
  def destroy
    @listowner.destroy
    head :no_content
  end
  
  private
  
  def listowner_params
    params.permit(:slist_id, :user_id)
  end
  
  def set_listowner
    @listowner = Listowner.find(params[:id])
  end
end
