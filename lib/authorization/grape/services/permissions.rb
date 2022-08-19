module Authorization
  module Grape
    module Services
      class Permissions < Base

        set_presenter "Authorization::Grape::Presenters::Permission"
        helpers Authorization::Grape::Helpers::Shared

        helpers do

          def permissions_collection permissions = Authorization::Role.new.permissions
            permissions.to_h
          end

        end

        resources "permissions" do

          desc "Get permissions"
          before do
            role_can_be_created? || role_can_be_edited?
          end
          get "" do
            permissions_collection
          end

        end

      end
    end
  end
end