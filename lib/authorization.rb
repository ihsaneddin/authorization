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

  def self.setup
    yield(self)
  end

end

require 'authorization/hooks'