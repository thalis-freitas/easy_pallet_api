require 'rails_helper'

describe Api::V1::LoadsController, type: :request do
  context 'GET /api/v1/loads' do
    before do
      @loads = create_list(:load, 5)
    end

    context 'successful requests' do
      it 'returns the expected number of loads' do
        get '/api/v1/loads'

        expect(response).to have_http_status(:success)
        expect(json[:loads].count).to eql(5)
      end

      it 'returns loads with expected attributes' do
        get '/api/v1/loads'

        json[:loads].each do |load|
          expect(load.keys).to include(*%i[id code delivery_date])
          expect(load.keys).not_to include(*%i[created_at updated_at])
        end
      end
    end

    context 'error handling' do
      it 'handles internal server error' do
        allow(Load).to receive(:page).and_raise(ActiveRecord::QueryCanceled)
        get '/api/v1/loads'

        expect(response).to have_http_status(:internal_server_error)
        expect(json).to include(error: 'Internal Server Error')
      end
    end
  end
end
