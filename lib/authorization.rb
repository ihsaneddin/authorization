require 'options_model'

require 'authorization/railtie' if defined?(Rails)
require 'authorization/configuration'
require 'authorization/permissions'
require 'authorization/permissions/concerns/models/role'
require "authorization/version"
require "authorization/engine"

module Authorization

  extend Configuration

  module Permissions
    autoload :PermissionSet, 'authorization/permissions/permission_set'
    autoload :ComputedPermissions, 'authorization/permissions/computed_permissions'
    autoload :Mapper, 'authorization/permissions/mapper'
    autoload :Permission, 'authorization/permissions/permission'
  end

  module Grape 
    autoload :Cancan, "authorization/grape/cancan"
    autoload :Endpoint, "authorization/grape/endpoint"
    autoload :Resource, "authorization/grape/resource"
    module Helpers
      autoload :Shared, "authorization/grape/helpers/shared"
    end
    module Presenters 
      autoload :Base, "authorization/grape/presenters/base"
      autoload :Role, "authorization/grape/presenters/role"
      autoload :Permission, "authorization/grape/presenters/permission"
    end
    module Services
      autoload :Base, "authorization/grape/services/base"
      autoload :Roles, "authorization/grape/services/roles"
      autoload :Permissions, "authorization/grape/services/permissions"
    end
  end

  def self.setup
    yield(self)
  end

end

require 'authorization/hooks'