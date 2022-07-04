module Authorization
  module Grape
    module Endpoint

      def self.included base
        base.class_eval do
          #
          # rescue from cancan access denied
          #
          rescue_from ::CanCan::AccessDenied do
            error!("Access denied!. 403 Forbidden", 403)
          end
        end

      end


    end
  end
end