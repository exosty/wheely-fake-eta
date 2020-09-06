# frozen_string_literal: true

require 'spec_helper'

describe GetCars do
  describe '#call' do
    subject(:result) { ApplicationContainer['get_cars'].call(lat, lng, limit) }

    let(:url) { ApplicationContainer['get_cars_config'].url }

    let(:lat) { 10.0 }
    let(:lng) { 20.0 }
    let(:limit) { 3 }
    let(:query) { { lat: lat, lng: lng, limit: limit } }

    context 'when succes' do
      let(:response_body) do
        [
          { 'id' => 55, 'lat' => 1.111, 'lng' => 2.222 },
          { 'id' => 33, 'lat' => 1.3111, 'lng' => 23.222 },
          { 'id' => 394, 'lat' => -12.3111, 'lng' => -35.222 }
        ].to_json
      end

      let(:correct_result) do
        [
          { 'lat' => 1.111, 'lng' => 2.222 },
          { 'lat' => 1.3111, 'lng' => 23.222 },
          { 'lat' => -12.3111, 'lng' => -35.222 }
        ]
      end

      before do
        stub_request(:get, url).with(query: query).to_return(status: 200, body: response_body)
      end

      it 'returns parsed array of cars' do
        aggregate_failures do
          expect(result.success?).to eq(true)
          expect(result.value!).to eq(correct_result)
        end
      end
    end

    context 'when bad response' do
      let(:error) { :get_cars_bad_response }
      let(:status) { 417 }
      let(:body) { "I'm a teapot" }

      let(:correct_result) do
        {
          error: error,
          response_status: status,
          response_body: body
        }
      end

      before do
        stub_request(:get, url).with(query: query).to_return(status: status, body: body)
      end

      it 'returns error with response' do
        aggregate_failures do
          expect(result.success?).to eq(false)
          expect(result.failure).to eq(correct_result)
        end
      end
    end

    context 'when HTTP Timeout' do
      let(:lat) { 10.0 }
      let(:lng) { 20.0 }
      let(:limit) { 3 }
      let(:query) { { lat: lat, lng: lng, limit: limit } }

      let(:correct_result) do
        {
          error: :get_cars_http_error,
          description: HTTP::TimeoutError.to_s
        }
      end

      before do
        stub_request(:get, url).with(query: query).to_raise(HTTP::TimeoutError.new)
      end

      it 'returns error with description' do
        aggregate_failures do
          expect(result.success?).to eq(false)
          expect(result.failure).to eq(correct_result)
        end
      end
    end
  end
end
