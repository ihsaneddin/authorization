module Authorization
  module Grape
    module Cancan

      def self.included base
        base.extend ClassMethods
        ::Grape::Endpoint.include HelperMethods if defined? ::Grape::Endpoint
      end

      module ClassMethods
        def authorize_routes!
          before { authorize_route! }
        end
      end

      module HelperMethods
        def current_ability
          @current_ability ||= ::Ability.new(current_user)
        end
        delegate :can?, :cannot?, :authorize!, to: :current_ability

        def authorize_route!
          opts = env['api.endpoint'].options[:route_options]
          authorize!(*opts[:authorize]) if opts.key?(:authorize)
        end
      end
    end
  end
end