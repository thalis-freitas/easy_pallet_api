require 'rails_helper'

describe 'Loads API', type: :request do
  context 'GET /api/v1/loads' do

    before do
      @loads = create_list(:load, 5)
      get '/api/v1/loads'
    end
    
    it { expect(response).to have_http_status(:success) }

    it 'returns the expected number of loads' do
      expect(json[:loads].count).to eql(5)
    end

    it 'success' do
      json[:loads].each do |load|
        expect(load.keys).to include(*%i[id code delivery_date])
        expect(load.keys).not_to include(*%i[created_at updated_at])
      end
    end
  end
end
