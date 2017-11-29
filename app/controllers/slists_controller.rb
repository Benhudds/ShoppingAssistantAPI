class SlistsController < ApplicationController
  before_action :set_slist, only: [:show, :update, :destroy]
  
  # GET /slists
  def index
    @slists = current_user.slists
    json_response(@slists)
  end
  
  # POST /slists
  def create
    @slist = current_user.slists.create!(slist_params)
    json_response(@slist, :created)
  end
  
  # GET /slists/:id
  def show
    json_response(@slist)
  end
  
  # PUT /slists/:id
  def update
    @slist.update(slist_params)
    head :no_content
  end
  
  # DELETE /slists/:id
  def destroy
    @slist.destroy
    head :no_content
  end
  
  private
  
  def slist_params
    params.permit(:name)
  end
  
  def set_slist
    @slist = Slist.find(params[:id])
  end
end
