require 'rails_helper'

RSpec.describe 'Iqps API' do
  let(:user) { create(:user) }
  let!(:slist) { create(:slist, created_by: user.id) }
  let!(:iqps) { create_list(:iqp, 20, slist_id: slist.id) }
  let(:slist_id) { slist.id }
  let(:id) { iqps.first.id }
  let(:headers) { valid_headers }
  
  # Test suite for GET /slists/:slist_id/iqps
  describe 'GET /slists/:slist_id/iqps' do
    before { get "/slists/#{slist_id}/iqps", params: {}, headers: headers }

    context 'when slist exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all slist iqps' do
        expect(json.size).to eq(20)
      end
    end

    context 'when slist does not exist' do
      let(:slist_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Slist/)
      end
    end
  end

  # Test suite for GET /slists/:slist_id/iqps/:id
  describe 'GET /slists/:slist_id/iqps/:id' do
    before { get "/slists/#{slist_id}/iqps/#{id}", params: {}, headers: headers }

    context 'when slist iqp exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the iqp' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when slist iqp does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Iqp/)
      end
    end
  end

  # Test suite for POST /slists/:slist_id/iqps
  describe 'POST /slists/:slist_id/iqps' do
    let(:valid_attributes) { { item: 'Eggs', quantity: 6 }.to_json }

    context 'when request attributes are valid' do
      before { post "/slists/#{slist_id}/iqps", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/slists/#{slist_id}/iqps", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Item can't be blank, Quantity can't be blank/)
      end
    end
  end

  # Test suite for PUT /slists/:slist_id/iqps/:id
  describe 'PUT /slists/:slist_id/iqps/:id' do
    let(:valid_attributes) { { item: 'Eggs', quantity: 6 }.to_json }

    before { put "/slists/#{slist_id}/iqps/#{id}", params: valid_attributes, headers: headers }

    context 'when iqp exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the iqp' do
        updated_iqp = Iqp.find(id)
        expect(updated_iqp.item).to match(/Eggs/)
        expect(updated_iqp.quantity).to match(6)
      end
    end

    context 'when the iqp does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Iqp/)
      end
    end
  end

  # Test suite for DELETE /slists/:id
  describe 'DELETE /slists/:id' do
    before { delete "/slists/#{slist_id}/iqps/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end