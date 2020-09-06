# frozen_string_literal: true

require 'spec_helper'

describe Predict do
  describe '#call' do
    subject(:result) { ApplicationContainer['predict'].call(lat, lng, cars) }

    let(:url) { ApplicationContainer['predict_config'].url }

    let(:lat) { 10.0 }
    let(:lng) { 20.0 }
    let(:cars) do
      [
        { 'lat' => 1.111, 'lng' => 2.222 },
        { 'lat' => 1.3111, 'lng' => 23.222 },
        { 'lat' => -12.3111, 'lng' => -35.222 }
      ]
    end
    let(:request_body) { { target: { lat: lat, lng: lng }, source: cars }.to_json }

    context 'when succes' do
      let(:correct_result) do
        [3, 2, 1]
      end

      before do
        stub_request(:post, url).with(body: request_body).to_return(status: 200, body: correct_result.to_json)
      end

      it 'returns parsed array of ETAs' do
        aggregate_failures do
          expect(result.success?).to eq(true)
          expect(result.value!).to eq(correct_result)
        end
      end
    end

    context 'when bad response' do
      let(:error) { :predict_bad_response }
      let(:status) { 417 }
      let(:response_body) { "I'm a teapot" }

      let(:correct_result) do
        {
          error: error,
          response_status: status,
          response_body: response_body
        }
      end

      before do
        stub_request(:post, url).with(body: request_body).to_return(status: status, body: response_body)
      end

      it 'returns error with response' do
        aggregate_failures do
          expect(result.success?).to eq(false)
          expect(result.failure).to eq(correct_result)
        end
      end
    end

    context 'when HTTP Timeout' do
      let(:correct_result) do
        {
          error: :predict_http_error,
          description: HTTP::TimeoutError.to_s
        }
      end

      before do
        stub_request(:post, url).with(body: request_body).to_raise(HTTP::TimeoutError.new)
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
