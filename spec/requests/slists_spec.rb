require 'rails_helper'

RSpec.describe 'Slists API', type: :request do
  # add slists owner
  let(:user) { create(:user) }
  let!(:slists) { create_list(:slist, 10) }
  let!(:slist_id) { slists.first.id }
  let!(:listowner1) { create(:listowner, slist_id: slists[0].id, user_id: user.id) }
  let!(:listowner2) { create(:listowner, slist_id: slists[1].id, user_id: user.id) }
  let!(:listowner3) { create(:listowner, slist_id: slists[2].id, user_id: user.id) }
  let!(:listowner4) { create(:listowner, slist_id: slists[3].id, user_id: user.id) }
  let!(:listowner5) { create(:listowner, slist_id: slists[4].id, user_id: user.id) }
  let!(:listowner6) { create(:listowner, slist_id: slists[5].id, user_id: user.id) }
  let!(:listowner7) { create(:listowner, slist_id: slists[6].id, user_id: user.id) }
  let!(:listowner8) { create(:listowner, slist_id: slists[7].id, user_id: user.id) }
  let!(:listowner9) { create(:listowner, slist_id: slists[8].id, user_id: user.id) }
  let!(:listowner10) { create(:listowner, slist_id: slists[9].id, user_id: user.id) }
  
  #authorize request
  let(:headers) { valid_headers }
  
  describe 'GET /slists/' do
    # make HTTP request before each example
    before { get '/slists', params: {}, headers: headers }
    
    it 'returns slists' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end
  
  describe 'GET  /slists/:id' do
    before { get "/slists/#{slist_id}", params: {}, headers: headers }
    
    context 'when the record exists' do
      it 'returns the slist' do
        expect(json).not_to be_empty
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the record does not exist' do
      let (:slist_id) { 100 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it  'returns a not found message' do
        expect(response.body).to match(/Couldn't find Slist/)
      end
    end
  end
  
  describe 'POST /slists' do
    let(:valid_attributes) do
      { name: 'Weekly Shop' }.to_json
    end
    
    context 'when the request is valid' do
      before { post '/slists', params: valid_attributes, headers: headers }
      
      it 'creates a slist' do
        expect(json).not_to be_empty
        expect(json['name']).to eq('Weekly Shop')
      end
      
      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when the request is invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before { post '/slists', params: valid_attributes, headers: headers }
      
      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe 'PUT /slists/:id' do
    let(:valid_attributes) { { name: 'Shopping' }.to_json }
    
    context 'when the record exists' do
      before { put "/slists/#{slist_id}", params: valid_attributes, headers: headers }
      
      it 'updates the record' do
        expect(response.body).to be_empty
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
  
  describe 'DELETE /slists/:id' do
    before { delete "/slists/#{slist_id}", params: {}, headers: headers }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end