begin; require 'grape'; rescue LoadError; end
begin; require 'grape_api'; rescue LoadError; end
begin; require 'cancancan'; rescue LoadError; end

if defined?(Grape::API) and defined?(CanCanCan)

  klass = if Grape::VERSION >= '1.2.0' || defined?(Grape::API::Instance)
    Grape::API::Instance
  else
    Grape::API
  end
  require 'authorization/grape/cancan'
  require 'authorization/grape/endpoint'
  klass.send(:include, Authorization::Grape::Cancan)
  klass.send(:include, Authorization::Grape::Endpoint)

  if defined? GrapeAPI::Endpoint::Base
    GrapeAPI::Endpoint::Base.send(:include, Authorization::Grape::Endpoint)
  end


  if defined?(GrapeAPI::Resourceful::Resource)
    require 'authorization/grape/resource'
    klass.include Authorization::Grape::Resource
  end


  if defined?(Grape::API) && defined?(GrapeAPI::Endpoint::Base)
    require "authorization/grape/services/base"

    Authorization::Grape::Services::Base.base.namespace :authorization do
      mount Authorization::Grape::Services::Roles
      mount Authorization::Grape::Services::Permissions
    end

  end

end
