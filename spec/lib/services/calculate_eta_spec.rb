# frozen_string_literal: true

require 'spec_helper'
require 'dry/monads/result'

describe CalculateEta do
  describe '#call' do
    before { ApplicationContainer.enable_stubs! }
    after do
      ApplicationContainer.unstub(:get_cars)
      ApplicationContainer.unstub(:predict)
    end

    subject(:result) { ApplicationContainer['calculate_eta'].call(lat, lng, limit) }

    let(:lat) { 10.0 }
    let(:lng) { 20.0 }
    let(:limit) { 3 }

    context 'when success' do
      before do
        ApplicationContainer.stub(:get_cars, ->(_lat, _lng, _limit) { Dry::Monads::Result::Success.new(cars) })
        ApplicationContainer.stub(:predict, ->(_lat, _lng, _cars) { Dry::Monads::Result::Success.new(eta_array) })
      end

      let(:cars) do
        [
          { 'lat' => 1.111, 'lng' => 2.222 },
          { 'lat' => 1.3111, 'lng' => 23.222 },
          { 'lat' => -12.3111, 'lng' => -35.222 }
        ]
      end
      let(:eta_array) { [3, 2, 1] }

      let(:correct_result) { 1 }

      it 'returns minimum ETA' do
        aggregate_failures do
          expect(result.success?).to eq(true)
          expect(result.value!).to eq(correct_result)
        end
      end
    end

    context 'when get cars returns failure' do
      before do
        ApplicationContainer.stub(:get_cars, ->(_lat, _lng, _limit) { Dry::Monads::Result::Failure.new(correct_result) })
        ApplicationContainer.stub(:predict, ->(_lat, _lng, _cars) { Dry::Monads::Result::Success.new(eta_array) })
      end

      let(:eta_array) { [3, 2, 1] }

      let(:correct_result) { { error: :some_failure } }

      it 'returns failure' do
        aggregate_failures do
          expect(result.success?).to eq(false)
          expect(result.failure).to eq(correct_result)
        end
      end
    end

    context 'when predict returns failure' do
      before do
        ApplicationContainer.stub(:get_cars, ->(_lat, _lng, _limit) { Dry::Monads::Result::Success.new(cars) })
        ApplicationContainer.stub(:predict, ->(_lat, _lng, _cars) { Dry::Monads::Result::Failure.new(correct_result) })
      end

      let(:cars) do
        [
          { 'lat' => 1.111, 'lng' => 2.222 },
          { 'lat' => 1.3111, 'lng' => 23.222 },
          { 'lat' => -12.3111, 'lng' => -35.222 }
        ]
      end

      let(:correct_result) { { error: :some_failure } }

      it 'returns error with description' do
        aggregate_failures do
          expect(result.success?).to eq(false)
          expect(result.failure).to eq(correct_result)
        end
      end
    end
  end
end
