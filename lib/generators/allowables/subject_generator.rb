require 'rails/generators/active_record'
require 'generators/allowables/orm_helpers'

module ActiveRecord
  module Allowables
    module Generators
      class SubjectGenerator < ActiveRecord::Generators::Base
        argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
        namespace "allowables:subject"

        include ::Allowables::Generators::OrmHelpers

        def generate_model
          invoke "active_record:model", [name], :migration => true unless model_exists? && behavior == :invoke
        end

        def inject_allowables_content
          content = <<CONTENT
  # Setup authorization for your subject model
  acts_as_authorization_subject
CONTENT

          class_path = if namespaced?
            class_name.to_s.split("::")
          else
            [class_name]
          end

          indent_depth = class_path.size - 1
          content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

          inject_into_class(model_path, class_path.last, content) if model_exists?
        end
      end
    end
  end
end