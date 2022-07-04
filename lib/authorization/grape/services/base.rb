require_relative "../helpers/shared"

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

require_relative "./roles"
require_relative "./permissions"