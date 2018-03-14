class ListownersController < ApplicationController
  before_action :set_listowner, only: [:show, :update, :destroy]
  
  # GET /listowners
  def index
    @listowners = Listowner.all
    json_response(@listowners)
  end
  
  # POST /listowners
  def create
    if (params[:email] != nil && params[:slist_id] != nil)
    
      # Check if submitting user is an owner
      if (!Listowner.where(slist_id: params[:slist_id], user_id: current_user.id).blank?)

        
        
        if (!User.where(email: params[:email]).blank?)
          newUser = User.where(email: params[:email]).first  

          # Check if new user is already an owner
          if (Listowner.where(slist_id: :slist_id, user_id: newUser.id).blank?)
            print "\n"
            print Listowner.where(:slist_id => params[:slist_id], user_id: newUser.id).blank?
            print "\n"
            Listowner.create!(:slist_id => params[:slist_id], :user_id => newUser.id)
          end
          
          json_response(newUser.id, :created)
          return
        end

        json_response("User not found", 422)
        return
      end
    end

    json_response("User not allowed to share this list with others", 422)
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
    params.permit(:slist_id, :user_id, :email)
  end
  
  def set_listowner
    @slist = Slist.find(params[:id])
  end
end
