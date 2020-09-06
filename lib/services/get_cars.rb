# frozen_string_literal: true

class GetCars
  extend Dry::Initializer
  include Dry::Monads[:result]

  option :logger
  option :config

  def call(lat, lng, limit)
    response = HTTP.get(config.url, params: { lat: lat, lng: lng, limit: limit })

    bad_response_failure(response) unless response.status.success?

    cars = Oj.load(response.body.to_s)

    Success(cars)
  rescue HTTP::Error => e
    Failure({ error: :get_cars_http_error, description: e })
  end

  private

  def bad_response_failure(response)
    Failure({
              error: :get_cars_bad_response,
              response_status: response.status.code,
              response_body: response.body.to_s
            })
  end
end