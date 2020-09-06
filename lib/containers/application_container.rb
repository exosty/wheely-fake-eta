# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  register(:calculate_eta) do
    CalculateEta.new(logger: self['logger'], get_cars: self['get_cars'], predict: self['predict'])
  end

  register(:get_cars) do
    GetCars.new(config: self['get_cars_config'])
  end

  register(:predict) do
    Predict.new(config: self['predict_config'])
  end

  register(:get_cars_config, memoize: true) do
    GetCarsConfig.new
  end

  register(:predict_config, memoize: true) do
    PredictConfig.new
  end

  register(:logger, memoize: true) do
    Logger.new($stdout)
  end
end
