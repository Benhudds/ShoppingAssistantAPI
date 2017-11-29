require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  
  # Initialise test data
  let!(:locations) { create_list(:location, 10) }
  let(:location_id) { locations.first.id }
  
  # Test suite for GET /locations
  describe 'GET /locations' do
    # make HTTP get request before each example
    before { get '/locations' }
    
    it 'returns locations' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  # Test suite for GET /locations/:id
  describe 'GET /locations/:id' do
    before { get "/locations/#{location_id}" }
    
    context 'when the record exists' do
      it 'returns the location' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(location_id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the record does not exist' do
      let(:location_id) { 0 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Location/)
      end
    end
  end
  
  # Test suite for POST /locations
  describe 'POST /locations' do
    let(:valid_attributes) { { name: 'Local Supermarket', lat: 53.7947766, lng: -2.9926801, vicinity: 'Clifton Retail Park, Clifton Rd, Blackpool', googleid: '123aed123' } }
    
    context 'when the request is valid' do
      before { post '/locations', params: valid_attributes }
      
      it 'creates a location' do
        expect(json).not_to be_empty
        expect(json['name']).to eq('Local Supermarket')
        expect(json['lat']).to eq(53.7947766)
        expect(json['lng']).to eq(-2.9926801)
        expect(json['vicinity']).to eq('Clifton Retail Park, Clifton Rd, Blackpool')
        expect(json['googleid']).to eq('123aed123')
      end
      
      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end
  
  # Test suite for PUT /locations/:id
  describe 'PUT /locations/:id' do
    let(:valid_attributes) { { name: 'Local Supermarket', lat: 53.7947766, lng: -2.9926801, vicinity: 'Clifton Retail Park, Clifton Rd, Blackpool' } }
    
    context 'when the record exists' do
      before { put "/locations/#{location_id}", params: valid_attributes }
      
      it 'updates the record' do
        expect(response.body).to be_empty
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
  
  # Test suite for DELETE /locations/:id
  describe 'DELETE /locations/:id' do
    before { delete "/locations/#{location_id}" }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end