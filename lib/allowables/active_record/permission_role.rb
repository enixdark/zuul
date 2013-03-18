module Allowables
  module ActiveRecord
    module PermissionRole
      def self.included(base)
        base.send :extend, ClassMethods
        base.send :include, ContextMethods # defined in lib/allowables/active_record.rb
      end

      module ClassMethods
        def self.extended(base)
          base.send :attr_accessible, :context, :context_id, :context_type, base.auth_scope.permission_foreign_key.to_sym, base.auth_scope.role_foreign_key.to_sym
          add_validations base
          add_associations base
        end

        def self.add_validations(base)
          base.send :validates_presence_of, base.auth_scope.permission_foreign_key.to_sym, base.auth_scope.role_foreign_key.to_sym
          base.send :validates_uniqueness_of, base.auth_scope.permission_foreign_key.to_sym, :scope => [base.auth_scope.role_foreign_key.to_sym, :context_id, :context_type], :case_sensitive => false
          base.send :validates_numericality_of, base.auth_scope.permission_foreign_key.to_sym, base.auth_scope.role_foreign_key.to_sym, :only_integer => true
        end

        def self.add_associations(base)
          base.send :belongs_to, base.auth_scope.permission_class_name.underscore.to_sym
          base.send :belongs_to, base.auth_scope.role_class_name.underscore.to_sym
        end
      end
    end
  end
end