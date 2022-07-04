require_relative "../presenters/role"

module Authorization
  module Grape
    module Services
      class Roles < Base

        fetch_resource_and_collection! do
          model_klass "Authorization::Role"
          attributes do
            optional :name, type: String
            optional :permissions_attributes, type: Hash
          end
        end

        set_presenter "Authorization::Grape::Presenters::Role"

        resources "roles" do

          desc "Get roles"
          get "" do
            roles_can_be_read? @roles
            presenter @roles
          end

          desc "Create new role"
          post '' do
            role_can_be_created? @role
            if @role.save
              presenter @role
            else
              standard_validation_error(details: @role.errors)
            end
          end

          desc "Update role"
          put ':id' do
            role_can_be_edited?(@role)
            if @role.update _resource_params
              presenter @role
            else
              standard_validation_error(details: @role.errors)
            end
          end

          desc "Delete role"
          delete ':id' do
            role_can_be_deleted?(@role)
            if @role.destroy
              presenter @role
            end
          end

        end

      end
    end
  end
end