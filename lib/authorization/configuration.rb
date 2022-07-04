module Authorization
  module Configuration

    module Role

      mattr_accessor :entity_class
      @@entity_class = "User"
      mattr_accessor :entity_relation_name
      @@entity_relation_name= nil
      mattr_accessor :entity_table_name
      @@entity_table_name = nil
      mattr_accessor :join_table
      @@join_table = :authorization_entities_roles
      mattr_accessor :dynamic_shortcuts
      @@dynamic_shortcuts = false
      mattr_accessor :remove_role_if_empty
      @@remove_role_if_empty = true


      class << self
        def setup(*role_cnames)
          return if !sanity_check(role_cnames)
          yield self if block_given?
        end

        def entity_class=(val)
          @@entity_class = val
        end

        def entity_table_name
          @@entity_table_name || @@entity_class.constantize.table_name rescue @entity_class.tableize
        end

        def entity_table_name=(val)
          @@entity_table_name = val
        end

        def entity_relation_name
          @@entity_relation_name.nil?? @@entity_class.demodulize.downcase.underscore.pluralize.to_sym : @@entity_relation_name
        end

        def entity_relation_name=(val)
          @@entity_relation_name = val
        end

        def remove_role_if_empty=(is_remove)
          @@remove_role_if_empty = is_remove
        end

        def remove_role_if_empty
          @@remove_role_if_empty
        end

        def use_dynamic_shortcuts
          return if !sanity_check([])
          self.dynamic_shortcuts = true
        end

        def use_defaults
          configure do |config|
            config.dynamic_shortcuts = false
          end
        end

        private

          def sanity_check(role_cnames)
            return true if ARGV.reduce(nil) { |acc,arg| arg =~ /assets:/ if acc.nil? } == 0

            role_cnames.each do |role_cname|
              role_class = role_cname.constantize
              if role_class.superclass.to_s == "ActiveRecord::Base" && role_table_missing?(role_class)
                warn "[WARN] table '#{role_cname}' doesn't exist. Did you run the migration?"
                return false
              end
            end
            true
          end

          def role_table_missing?(role_class)
            !role_class.table_exists?
          rescue ActiveRecord::NoDatabaseError
            true
          end
      end

    end

    module Permission

      class << self

        def setup &block
          yield self
        end

        def permission_set_class
          @permission_set_class ||= Authorization::Permissions::PermissionSet.derive "Global"
        end

        def permission_set_class=(klass)
          raise ArgumentError, "#{klass} should be sub-class of #{Authorization::Permissions::PermissionSet}." unless klass && klass < Authorization::Permissions::PermissionSet

          @permission_set_class = klass.derive "Global"
        end

        def permission_class
          @permission_class ||= Authorization::Permissions::Permission
        end

        def permission_class=(klass)
          raise ArgumentError, "#{klass} should be sub-class of #{Authorization::Permissions::Permission}." unless klass && klass < Authorization::Permissions::Permission

          @permission_class = klass
        end

      end

    end

    module Access

      mattr_accessor :current_user_proc
      @@current_user_proc = nil

      mattr_accessor :can_be_read_by_proc
      @@can_be_read_by_proc = true

      mattr_accessor :can_be_created_by_proc
      @@can_be_created_by_proc = true

      mattr_accessor :can_be_edited_by_proc
      @@can_be_edited_by_proc = true

      mattr_accessor :can_be_deleted_by_proc
      @@can_be_deleted_by_proc = true

      class << self
        def setup &block
          yield self
        end

        def current_user context = nil
          if block_given?
            @@current_user_proc = Proc.new
          else
            @@current_user_proc.call(context)
          end
        end

        def can_be_read_by current_user = nil, role = nil, context = nil
          if block_given?
            @@can_be_read_by_proc = Proc.new
          else
            @@can_be_read_by_proc.call(current_user, role, context)
          end
        end

        def can_be_created_by current_user = nil, role = nil, context = nil
          if block_given?
            @@can_be_created_by_proc = Proc.new
          else
            @@can_be_created_by_proc.call(current_user, role, context)
          end
        end

        def can_be_edited_by current_user = nil, role = nil, context = nil
          if block_given?
            @@can_be_edited_by_proc = Proc.new
          else
            @@can_be_edited_by_proc.call(current_user, role, context)
          end
        end

        def can_be_deleted_by current_user = nil, role = nil, context = nil
          if block_given?
            @@can_be_deleted_by_proc = Proc.new
          else
            @@can_be_deleted_by_proc.call(current_user, role, context)
          end
        end
      end

    end

    mattr_accessor :role
    @@role = Role
    mattr_accessor :permission
    @@permission = Permission
    mattr_accessor :access
    @@access = Access

  end
end