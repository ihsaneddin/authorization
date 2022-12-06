# frozen_string_literal: true

module Authorization
  module Permissions
    module Concerns
      module Models
        module Role
          extend ActiveSupport::Concern

          included do
            validates :name,
                      presence: true

            delegate :computed_permissions, to: :permissions

            serialize :permissions, Authorization.permission.permission_set_class

            after_save do
              if saved_change_to_attribute? :permissions
                self.class.reflect_on_all_associations.each do |assoc|
                  if assoc.klass.roles_permissions_is_attached
                    has_permissions = self.send(assoc.name) rescue []
                    has_permissions.each do |hp|
                      hp.sync_permissions
                    end
                  end
                end
              end
            end

          end

          def permissions_attributes=(value)
            self[:permissions].replace value
          end
        end
      end
    end
  end
end
1