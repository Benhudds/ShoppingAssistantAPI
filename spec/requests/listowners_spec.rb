require 'rails_helper'

RSpec.describe 'Listowners API', type: :request do
  # Create the users
  let!(:owner) { create(:user) }
  let!(:user) { create(:user) }
  
  # Create the shopping list
  let!(:slist) { create(:slist) }
  
  # Create the list owner
  let!(:listowner) { create(:listowner, slist_id: slist.id, user_id: user.id)  }
  
  # Create the required authorization headers for the requests
  let(:headers) { valid_headers }
  
  describe 'POST /share' do
    let(:valid_attributes) do
      { email: owner.email, slist_id: slist.id }.to_json
    end
    
    context 'when the request is valid' do
      before { post '/share', params: valid_attributes, headers: headers }
      
      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when the request is invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before { post '/share', params: valid_attributes, headers: headers }
      
      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end
    end
    
    context 'when the user does not own the slist' do
      let(:valid_attributes) do
        { email: user.email, slist_id: slist.id }.to_json
      end
        let(:headers) { { 'Authorization' => token_generator(user.id) } }
      
      before { post '/share', params: valid_attributes, headers: headers }
      
      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end