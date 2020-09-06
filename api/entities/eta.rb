# frozen_string_literal: true

module Api
  module Entities
    class Eta < Grape::Entity
      expose :eta,
             documentation: {
               type: Integer,
               desc: 'Car receiving ETA in minutes'
             }
    end
  end
end
