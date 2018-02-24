require 'rails_helper'

RSpec.describe "DeleteOldIplsController", type: :controller do

  let!(:location) { create(:location, id: TescoapiController.getForeignKey) }
  let!(:ipls) { create_list(:ipl, 20, location_id: location.id, created_at: 1.week.ago, updated_at: 1.week.ago) }

  describe DeleteOldIplsController do
    context "when the method is called" do
      
      it "deletes the old ipls" do
        
          DeleteOldIplsController.perform()
          expect(Ipl.where(location_id: location.id)).not_to exist
      end
    end
 
  end
end
