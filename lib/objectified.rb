# frozen_string_literal: true

require "objectified/version"

require "active_support"
require "active_support/rails"
require "active_support/core_ext/string/inflections"
require "active_support/lazy_load_hooks"

# include this module to have resource based, meta programming variables.
module Objectified
  extend ActiveSupport::Autoload

  def self.included(base)
    base.class_eval do
      extend ClassMethods

      def self.inherited(subclass)
        super
        subclass.object_type(object_type_string)
      end
    end
  end

  # e.g. define object_type :finder for ApplicationFinder
  module ClassMethods
    attr_accessor :object_type_string

    #
    # The entry point of the api is the :object_type method.
    #
    #
    # Note:
    #    Do not use for classes with the prefix 'Application'.
    #
    # Args:
    #    object_type_string: (String)
    #
    # Example:
    #    class SomeController
    #      object_type :controller
    #    end
    #
    #    SomeController.resource_klass_string
    #      => 'Some'
    #

    def object_type(object_type_string)
      @object_type_string = object_type_string
    end


    #
    # Returns the 'object_type' but capitalized and stringified
    #
    # Example:
    #    SomeController.object_type_klass_string
    #      => 'Controller'
    #

    def object_type_klass_string
      @object_type_string&.to_s&.camelcase
    end


    #
    # Returns the pluralized resource name
    #
    # Example:
    #    SomeController.resources_klass_string
    #      => 'Somes'
    #

    def resources_klass_string
      unless object_type_klass_string
        raise 'No Object Type Defined. please override object_type in your class => e.g. object_type :controller'
      end

      to_s.gsub(object_type_klass_string, '').pluralize
    end


    #
    # Returns the singularized resource name
    #
    # Example:
    #    SomeController.resource_klass_string
    #      => 'Some'
    #

    def resources_klass_string
      resources_klass_string.singularize
    end


    #
    # Returns the constantized class name of the resource
    #
    # Example:
    #    SomeController.records_klass
    #      => 'Some'
    #

    def records_klass
      return if resource_klass_string == 'Application'

      resource_klass_string&.constantize
    rescue NameError
      resource_klass_string
    end


    #
    # Returns the name of a the **collection variable** for the resource class, with the option of stripping it's namespaces.
    #
    # Example:
    #    SomeNamespace::SomeController.records_instance_variable_name
    #      => 'some_namespace_somes'
    #
    # Example:
    #    SomeNamespace::SomeController.records_instance_variable_name(namespace: true)
    #      => 'somes'
    #

    def records_instance_variable_name(namespace: false)
      return if resource_klass_string == 'Application'

      if namespace
        records_klass.to_s.underscore.downcase.pluralize.gsub('/', '_')
      else
        records_klass.to_s.underscore.downcase.pluralize.split('/').last
      end
    end


    #
    # Returns the name of a the **member variable** for the resource class, with the option of stripping it's namespaces.
    #
    # Example:
    #    SomeNamespace::SomeController.record_instance_variable_name
    #      => 'some_namespace_some'
    #
    # Example:
    #    SomeNamespace::SomeController.record_instance_variable_name(namespace: true)
    #      => 'some'
    #

    def record_instance_variable_name(namespace: false)
      return if resource_klass_string == 'Application'

      if namespace
        records_klass.to_s.underscore.downcase
      else
        records_klass.to_s.underscore.downcase.split('/').last
      end
    end


    #
    # Mixin to extract class names on demand.
    #
    # Example:
    #    SomeNamespace::SomeController.record_instance_variable_name
    #      => 'some_namespace_some'
    #
    # Example:
    #    SomeNamespace::SomeController.record_instance_variable_name(namespace: true)
    #      => 'some'
    #
    def object_klass_for(object_type)
      str = "#{resource_klass_string.pluralize}#{object_type.to_s.camelize}"
      str.constantize
    end
  end

  #
  # Instance Extensions of Class Methods
  #

  def records_instance_variable_name(namespace: false)
    self.class.records_instance_variable_name(namespace: namespace)
  end

  def record_instance_variable_name(namespace: false)
    self.class.record_instance_variable_name(namespace: namespace)
  end

  def records_klass
    self.class.records_klass
  end

  def resource_klass_string
    self.class.resource_klass_string
  end

  def object_klass_for(object_type)
    self.class.object_klass_for(object_type)
  end

  def resources_klass_string
    self.class.resources_klass_string
  end
end

