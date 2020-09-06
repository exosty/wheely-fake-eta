# frozen_string_literal: true

class CalculateEta
  extend Dry::Initializer

  option :logger
  option :get_cars
  option :predict

  def call(lat, lng, limit)
    # logger.info("#{lat}, #{lng}, #{limit}")
  end
end
