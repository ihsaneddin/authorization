require 'authorization'
require 'authorization/roles'
require 'authorization/permissions'
require 'authorization/roles_permissions'
require 'rails'

module Authorization
  class Railtie < Rails::Railtie
    initializer 'authorization.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Authorization::Roles
        ActiveRecord::Base.send :extend, Authorization::Permissions
        ActiveRecord::Base.send :extend, Authorization::RolesPermissions
      end
    end
  end
end