module Authorization::RolesPermissions
  module RolesPermissionsMethods

    def add_permissions_from_role role
      add_permissions role.permissions.to_h
    end

    def add_permissions _permissions
      self.permissions_attributes= self.permissions.to_h.deep_merge(_permissions) { |key, this_val, other_val| this_val || other_val  }
      self.save validate: false
    end

    def remove_permissions_from_role role
      remove_permissions role.permissions
    end

    def remove_permissions _permissions
      self.permissions_attributes= Authorization.permission.permission_set_class.new
      _roles = self.roles
      if roles.blank?
        self.save validate: false
      else
        _roles.each do |role|
          add_permissions_from_role role
        end
      end
    end

    def sync_permissions
      self.permissions_attributes= Authorization.permission.permission_set_class.new
      _roles = self.roles
      unless _roles.blank?
        _roles.each do |role|
          add_permissions_from_role role
        end
      end
    end

  end
end
