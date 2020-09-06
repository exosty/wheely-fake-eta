# frozen_string_literal: true

class Predict
  extend Dry::Initializer
  include Dry::Monads[:result]

  option :config

  def call(lat, lng, cars)
    response = HTTP.headers(headers).post(config.url, body: body(lat, lng, cars))

    return bad_response_failure(response) unless response.status.success?

    eta_array = Oj.load(response.body.to_s)

    Success(eta_array)
  rescue HTTP::Error => e
    Failure({ error: :predict_http_error, description: e.to_s })
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def body(lat, lng, cars)
    {
      target: {
        lat: lat,
        lng: lng
      },
      source: cars
    }.to_json
  end

  def bad_response_failure(response)
    Failure({
              error: :predict_bad_response,
              response_status: response.status.code,
              response_body: response.body.to_s
            })
  end
end
