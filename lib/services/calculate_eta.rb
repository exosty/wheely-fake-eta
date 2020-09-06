# frozen_string_literal: true

class CalculateEta
  extend Dry::Initializer

  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  option :logger
  option :get_cars
  option :predict

  def call(lat, lng, limit)
    logger.info("Start processing for lat: #{lat}, lng: #{lng}, limit: #{limit}")

    cars = yield get_cars.call(lat, lng, limit)

    logger.info("Got cars from GetCars service: #{cars}")

    Success(5)
  end
end
