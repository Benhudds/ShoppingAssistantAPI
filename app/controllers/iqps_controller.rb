class IqpsController < ApplicationController
  before_action :set_slist
  before_action :set_slist_iqp, only: [:show, :update, :destroy]
  
  # GET /slists/:slist_id/iqps
  def index
     json_response(@slist.iqps)
  end
  
  # GET /slists/:slist_id/iqps/:id
  def show
    json_response(@iqp)
  end
  
  # POST /slists/:slist_id/iqps
  def create
    @slist.iqps.create!(iqp_params)
    json_response(@slist, :created)
  end
  
  # PUT /slists/:slist_id/iqps/:id
  def update
    @iqp.update(iqp_params)
    head :no_content
  end
  
  # DELETE /slists/:slist_id/iqps/:id
  def destroy
    @iqp.destroy
    head :no_content
  end
  
  private
  
  def iqp_params
    params.permit(:item, :quantity)
  end
  
  def set_slist
    @slist = Slist.find(params[:slist_id])
  end
  
  def set_slist_iqp
    @iqp = @slist.iqps.find_by!(id: params[:id]) if @slist
  end
end
