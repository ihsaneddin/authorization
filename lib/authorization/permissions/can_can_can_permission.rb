# frozen_string_literal: true

module Authorization
  module Permissions
    class CanCanCanPermission < Permission
      attr_reader :action, :options

      def initialize(name, _namespace: [], _priority: 0, _callable: true, **options, &block)
        super
        return unless _callable

        @model_name = options[:model_name]
        @subject = options[:subject]
        @action = options[:action] || name
        @condition_proc = options[:condition_proc]
        @options = options.except(:model, :model_name, :subject, :action, :condition_proc)
        @block = block
      end

      def call(context, *args)
        return unless callable

        subject = @subject || @model_name.constantize
        if block_attached?
          context.can @action, subject, &@block.curry[*args]
        else
          additional_options = if @condition_proc
            @condition_proc.call(*args)
          else
            {}
          end
          context.can @action, subject, @options.merge(additional_options)
        end
      rescue NameError
        raise "You must provide a valid model name."
      end

      def block_attached?
        !!@block
      end
    end
  end
end
