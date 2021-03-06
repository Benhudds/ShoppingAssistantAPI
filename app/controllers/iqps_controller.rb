class IqpsController < ApplicationController
  before_action :set_slist
  before_action :set_slist_iqp, only: [:show, :update, :destroy]
  
  # GET /slists/:slist_id/iqps
  def index
    @slist.iqps.each do |iqp|
      if Rails.env.production?
        Resque.enqueue(TescoapiController, iqp.item)
        Resque.enqueue(IcelandwebController, iqp.item)
      end
    end
    
    json_response(@slist.iqps)
  end
  
  # GET /slists/:slist_id/iqps/:id
  def show
    json_response(@iqp)
  end
  
  # POST /slists/:slist_id/iqps
  def create
    iqps = Iqp.where(slist_id: @slist.id).where(item: params[:item])
    if (!iqps.blank?)
      json_response("There is already an ipq for this item", 400)
      return
    end
    
    @iqp = @slist.iqps.create!(iqp_params)
    @slist.updated_at = Time.now
    @slist.save
    if Rails.env.production?
      on_new_iqp(@iqp)
    end
    json_response(@iqp, :created)
  end
  
  # PUT /slists/:slist_id/iqps/:id
  def update
    @oldQuantity = @iqp.quantity
    if @iqp.quantity != params['quantity']
      @iqp.update(iqp_params)
      if Rails.env.production?
        on_modified_iqp(@iqp, @oldQuantity)
      end
    end
    head :no_content
  end
  
  # DELETE /slists/:slist_id/iqps/:id
  def destroy
    on_deleted_iqp(@iqp)
    @iqp.destroy
    head :no_content
  end
  
  private
  
  def getListOwners
    return Listowner.where(slist_id: @slist.id).where("user_id != " + current_user.id.to_s)
  end
  
  def on_new_iqp(iqp)
    Resque.enqueue(TescoapiController, iqp.item)
    Resque.enqueue(IcelandwebController, iqp.item)
    
    # Send the users (but not the current one) an email
    @users_to_email = getListOwners
    @users_to_email.each do |owner|
      user = User.find(owner.user_id)
      UserMailer.new_item_email(current_user, user, @slist, iqp).deliver_later
    end
    
  end
  
  def on_deleted_iqp(iqp)
    @users_to_email = getListOwners
    @users_to_email.each do |owner|
      user = User.find(owner.user_id)
      UserMailer.deleted_item_email(current_user, user, @slist, iqp).deliver_later
    end
  end
  
  def on_modified_iqp(iqp, oldQuantity)
    @users_to_email = getListOwners
    @users_to_email.each do |owner|
      user = User.find(owner.user_id)
      
      UserMailer.modified_item_email(current_user, user, @slist, iqp, oldQuantity).deliver_later
    end
  end
  
  def iqp_params
    params.permit(:item, :quantity, :measure)
  end
  
  def set_slist
    @slist = Slist.find(params[:slist_id])
  end
  
  def set_slist_iqp
    @iqp = @slist.iqps.find_by!(id: params[:id]) if @slist
  end
end
