require "dynamic_text_generator/version"

module DynamicTextGenerator
  class Error < StandardError; end
  # Your code goes here...
  module Generatable
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def template_model(template_model)
        @template_model_class = Object.const_get(template_model.to_s.camelize)
      end

      def template_columns(*args)
        args.each do |column_name|
          define_method "text_#{column_name.to_s}" do
            generate_template(notice_template.send(column_name), @instance_for_template)
          end
        end
      end
    end

    private

    def notice_template
      @notice_template ||= self.class.instance_variable_get("@template_model_class").find(@template_id)
    end

    def generate_template(template, obj)
      merge_params(template, obj).each do |key, value|
        template.gsub!(key, value.to_s)
      end
      template
    end

    def merge_params(body, obj)
      params = {}
      body.scan(/%{[\@\w\.]+}/).map do |key|
        params[key] = nil
      end
      return params if params.size == 0
      params.each do |key, _|
        params[key] = eval(key[2..-2])
      end
      params
    end
  end
end
