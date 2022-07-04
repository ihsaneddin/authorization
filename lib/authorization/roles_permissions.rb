require "authorization/roles_permissions/roles_permissions_methods"

module Authorization
  module RolesPermissions

    extend Authorization::Roles
    extend Authorization::Permissions

    def has_roles_permissions
      include RolesPermissionsMethods
      has_permissions
      has_roles :after_add => :add_permissions_from_role, after_remove: :remove_permissions_from_role
    end

  end
end