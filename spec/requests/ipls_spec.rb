require 'rails_helper'

RSpec.describe 'Ipls API' do
  
  # Initialise test data
  let!(:location) { create(:location) }
  let!(:ipls) { create_list(:ipl, 20, location_id: location.id) }
  let(:location_id) { location.id }
  let(:id) { ipls.first.id }
  
 # Test suite for GET /locations/:location_id/ipls
  describe 'GET /locations/:location_id/ipls' do
    before { get "/locations/#{location_id}/ipls" }

    context 'when location exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all location ipls' do
        expect(json.size).to eq(20)
      end
    end

    context 'when location does not exist' do
      let(:location_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Location/)
      end
    end
  end

  # Test suite for GET /locations/:location_id/ipls/:id
  describe 'GET /locations/:location_id/ipls/:id' do
    before { get "/locations/#{location_id}/ipls/#{id}" }

    context 'when location ipl exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the ipl' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when location ipl does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Ipl/)
      end
    end
  end

  # Test suite for POST /locations/:location_id/ipls
  describe 'POST /locations/:location_id/ipls' do
    let(:valid_attributes) { { price: 3.25, name: "jam", location_id: location_id } }

    context 'when request attributes are valid' do
      before { post "/locations/#{location_id}/ipls", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/locations/#{location_id}/ipls", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Price can't be blank, Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /locations/:location_id/ipls/:id
  describe 'PUT /locations/:location_id/ipls/:id' do
    let(:valid_attributes) { { price: 3.25 } }

    before { put "/locations/#{location_id}/ipls/#{id}", params: valid_attributes }

    context 'when ipl exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the ipl' do
        updated_ipl = Ipl.find(id)
        expect(updated_ipl.price).to match(3.25)
      end
    end

    context 'when the ipl does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Ipl/)
      end
    end
  end

  # Test suite for DELETE /locations/:id
  describe 'DELETE /locations/:id' do
    before { delete "/locations/#{location_id}/ipls/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end