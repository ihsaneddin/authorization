module Authorization
  module Generators
    class CanCanAbilityGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def generate_config
        if defined? CanCanCan
          copy_file "ability.rb", "app/models/ability.rb"
        else
          Kernel.warn <<-WARNING.gsub(/^\s{4}/, '')
            Warning: this command relies on Cancancan.
            Please install it by adding one of the following to your Gemfile:

            gem 'cancancan'
          WARNING
        end
      end
    end
  end
end