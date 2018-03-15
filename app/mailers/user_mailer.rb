class UserMailer < ApplicationMailer
  default from: 'ShoppingAssistantApplication@gmail.com'
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to ShoppingAssistant')
  end
  
  def new_item_email(current_user, user, slist, iqp)
    @current_user = current_user
    @user = user
    @slist = slist
    @iqp = iqp
    mail(to: @user.email, subject: 'Updated ' + @slist.name)
  end
  
  def deleted_item_email(current_user, user, slist, iqp)
    @current_user = current_user
    @user = user
    @slist = slist
    @iqp = iqp
    mail(to: @user.email, subject: 'Updated ' + @slist.name)
  end
  
  def modified_item_email(current_user, user, slist, iqp, oldQuantity)
    @current_user = current_user
    @user = user
    @slist = slist
    @iqp = iqp
    @oldQuantity = oldQuantity
    mail(to: @user.email, subject: 'Updated ' + @slist.name)
  end
  
  def shared_slist_email(current_user, user, slist)
    @current_user = current_user
    @user = user
    @slist = slist
    mail(to: @user.email, subject: @current_user.name + ' has shared their shopping list ' + @slist.name + ' with you.')
  end
end
