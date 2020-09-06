# frozen_string_literal: true

class GetCars
  extend Dry::Initializer

  option :logger
  option :config

  def call(lat, lng, limit)

  end
end
