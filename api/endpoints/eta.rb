# frozen_string_literal: true

module Api
  module Endpoints
    class Eta < Grape::API
      desc 'Calculates ETA car receiving by coordinates' do
        success Entities::Eta
      end

      params do
        requires :lat, type: Float, allow_blank: false, values: -90.0..+90.0
        requires :lng, type: Float, allow_blank: false, values: -180.0..+180.0
        optional :limit, type: Integer, values: 0..10, default: 5
      end

      get 'eta' do
        args = params.values_at('lat', 'lng', 'limit')
        { eta: ApplicationContainer['calculate_eta'].call(*args) }
      end
    end
  end
end
