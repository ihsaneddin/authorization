module Authorization
  module Grape
    module Presenters

      class Role < Base
        expose :id
        expose :name do |res|
          res.name
        end
        expose :permissions do |res|
          res.permissions.to_h
        end
      end

    end
  end
end