module Authorization
  module Grape
    module Presenters

      class Permission < Base
        expose :name
      end

    end
  end
end