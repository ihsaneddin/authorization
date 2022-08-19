module Authorization
  module Grape
    module Helpers
      module Shared

        def role_current_user
          @current_user||=  Authorization.access.current_user(self)
        end

        def roles_can_be_read? role = nil
          unless Authorization.access.can_be_read_by(role_current_user, role, self)
            unauthorized_action
          end
        end

        def role_can_be_created? role = nil
          unless Authorization.access.can_be_created_by(role_current_user, role, self)
            unauthorized_action
          end
        end

        def role_can_be_edited? role = nil
          unless Authorization.access.can_be_edited_by_proc.call(role_current_user, role, self)
            unauthorized_action
          end
        end

        def role_can_be_deleted? role = nil
          unless Authorization.access.can_be_deleted_by_proc.call(role_current_user, role, self)
            unauthorized_action
          end
        end

        def role_scope query
          Authorization          
        end

        def unauthorized_action!
          error!({details: "Unauthorized Action"}, 401)
        end

        def t *args
          I18n.t *args
        end

      end
    end
  end
end