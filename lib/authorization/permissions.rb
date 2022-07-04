module Authorization
  module Permissions

    def has_permissions options = { permissions_field: :permissions }
      permissions_field = options[:permissions_field]
      if permissions_field.to_s != 'permissions'
        alias_attrubute options[:permissions_field], :permissions
      end

      delegate :computed_permissions, to: :permissions
      serialize permissions_field.to_sym, Authorization.permission.permission_set_class

      class_eval %{
        def permissions_attributes=(value)
          self[:permissions].replace value
        end
      }
    end

  end
end