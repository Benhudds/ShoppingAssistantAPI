require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
  let!(:user) { create(:user) }
  
  describe "notify" do
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to ShoppingAssistant")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["ShoppingAssistantApplication@gmail.com"])
    end
  end
end
