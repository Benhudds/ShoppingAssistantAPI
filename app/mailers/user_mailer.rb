class UserMailer < ApplicationMailer
  default from: 'ShoppingAssistantApplication@gmail.com'
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to ShoppingaAssistant')
  end
end
