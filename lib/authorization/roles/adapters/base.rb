module Authorization::Roles
  module Adapters
    class Base
      def initialize(role_cname, user_cname)
        @role_cname = role_cname
        @user_cname = user_cname
      end

      def role_class
        @role_cname.constantize
      end

      def user_class
        @user_cname.constantize
      end

      def role_table
        role_class.table_name
      end

      def self.create(adapter, role_cname, user_cname)
        load "authorization/roles/adapters/#{adapter}.rb"
        load "authorization/roles/adapters/scopes.rb"
        Authorization::Roles::Adapters.const_get(adapter.camelize.to_sym).new(role_cname, user_cname)
      end

      def relation_types_for(relation)
        relation.descendants.map(&:to_s).push(relation.to_s)
      end
    end

    class RoleAdapterBase < Adapters::Base
      def where(relation, args)
        raise NotImplementedError.new("You must implement where")
      end

      def find_or_create_by(role_name, resource_type = nil, resource_id = nil)
        raise NotImplementedError.new("You must implement find_or_create_by")
      end

      def add(relation, role_name, resource = nil)
        raise NotImplementedError.new("You must implement add")
      end

      def remove(relation, role_name, resource = nil)
        raise NotImplementedError.new("You must implement delete")
      end

      def exists?(relation, column)
        raise NotImplementedError.new("You must implement exists?")
      end
    end

    class ResourceAdapterBase < Adapters::Base
      def resources_find(roles_table, relation, role_name)
        raise NotImplementedError.new("You must implement resources_find")
      end

      def in(resources, roles)
        raise NotImplementedError.new("You must implement in")
      end

    end
  end
end