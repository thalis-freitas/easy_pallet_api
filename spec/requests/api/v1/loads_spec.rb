require 'rails_helper'

describe Api::V1::LoadsController, type: :request do
  describe 'GET /api/v1/loads' do
    before { @loads = create_list(:load, 5) }

    context 'successful request' do
      before { get '/api/v1/loads' }

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected number of loads' do
        expect(json[:loads].count).to eql(5)
      end

      it 'returns loads with expected attributes' do
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

  describe 'POST /api/v1/loads' do
    context 'successful request' do
      before do
        @load_attributes = attributes_for(:load)
        post '/api/v1/loads', params: { load: @load_attributes }
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates a new load with the provided attributes' do
        expect(json[:code]).to eq(@load_attributes[:code])
        expect(json[:delivery_date].to_date)
          .to eq(@load_attributes[:delivery_date])
      end
    end

    context 'with invalid params' do
      before do
        post '/api/v1/loads', params: { load: { code: nil } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if load is invalid' do
        expect(json[:errors])
          .to include('Código não pode ficar em branco')

        expect(json[:errors])
          .to include('Data de entrega não pode ficar em branco')
      end
    end
  end

  describe 'PUT /api/v1/loads/:id' do
    context 'with valid params' do
      before do
        @load = create(:load)
        @load_attributes = attributes_for(:load)

        put "/api/v1/loads/#{@load.id}", params: { load: @load_attributes }
      end

      it { expect(response).to have_http_status(:ok) }

      it 'updates the load with the provided attributes' do
        @load.reload

        expect(@load.code).to eq(@load_attributes[:code])
        expect(@load.delivery_date.to_date)
          .to eq(@load_attributes[:delivery_date])
      end
    end

    context 'with invalid params' do
      before do
        @load = create(:load)
        @invalid_attributes = { delivery_date: nil, code: nil }

        put "/api/v1/loads/#{@load.id}", params: { load: @invalid_attributes }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if load is invalid' do
        expect(json).to include(:errors)
      end
    end
  end
end
