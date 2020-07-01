require "objectified/version"

# frozen_string_literal: true

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

    def object_type(object_type_string)
      @object_type_string = object_type_string
    end

    def object_klass_string
      @object_type_string&.to_s&.camelcase
    end

    def records_klass_string
      unless object_klass_string
        raise 'No Object Type Defined. please override object_type in your class => e.g. object_type :controller'
      end

      to_s.gsub(object_klass_string, '').singularize
    end

    def abstract_klass_string
      unless object_klass_string
        raise 'No Object Type Defined. please override object_type in your class => e.g. object_type :controller'
      end

      to_s.gsub(object_klass_string, '')
    end

    def records_klass
      return if records_klass_string == 'Application'

      records_klass_string&.constantize
    rescue NameError
      records_klass_string
    end

    def records_instance_variable_name(namespace: false)
      return if records_klass_string == 'Application'

      if namespace
        records_klass.to_s.underscore.downcase.pluralize
      else
        records_klass.to_s.underscore.downcase.pluralize.split('/').last
      end
    end

    def record_instance_variable_name(namespace: false)
      return if records_klass_string == 'Application'

      if namespace
        records_klass.to_s.underscore.downcase
      else
        records_klass.to_s.underscore.downcase.split('/').last
      end
    end

    def object_klass_for(object_type)
      str = "#{records_klass_string.pluralize}#{object_type.to_s.camelize}"
      str.constantize
    end
  end

  def records_instance_variable_name(namespace: false)
    self.class.records_instance_variable_name(namespace: namespace)
  end

  def record_instance_variable_name(namespace: false)
    self.class.record_instance_variable_name(namespace: namespace)
  end

  def records_klass
    self.class.records_klass
  end

  def records_klass_string
    self.class.records_klass_string
  end

  def object_klass_for(object_type)
    self.class.object_klass_for(object_type)
  end

  def abstract_klass_string
    self.class.abstract_klass_string
  end
end

