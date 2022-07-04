require 'authorization'
require 'authorization/roles'
require 'rails'

module Authorization::Roles
  class Railtie < Rails::Railtie
    initializer 'authorization-roles.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Authorization::Roles
      end
    end
  end
end