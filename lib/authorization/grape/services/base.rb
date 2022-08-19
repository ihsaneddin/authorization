module Authorization
  module Grape
    module Services
      class Base < ::GrapeAPI::Endpoint::Base

        format :json

        helpers Authorization::Grape::Helpers::Shared

      end
    end
  end
end