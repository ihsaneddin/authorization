module Authorization
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def generate_config
        copy_file "authorization.rb", "config/initializers/authorization.rb"
        copy_file "authorization.en.yml", "config/locales/authorization.en.yml"
      end
    end
  end
end