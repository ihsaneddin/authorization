require 'grape-entity'

module Authorization
  module Grape
    module Presenters

      class Base < ::Grape::Entity
        root "data", "data"
      end

    end
  end
end