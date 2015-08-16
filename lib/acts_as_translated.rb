require 'acts_as_translated/version'


module ActsAsTranslated

  require 'acts_as_translated/railtie' if defined? Rails::Railtie

  def self.included(base)

    class << base
      attr_accessor :translated_attributes
    end

    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_translated(*args, default: :en)
      self.translated_attributes ||= {}

      args.each do |field|
        self.translated_attributes[field.to_sym] = default.to_sym
      end

      # self.translated_fields = Array.new if self.translated_fields.blank?
      # self.translated_fields << fields
      # self.translated_fields.flatten!
      # class_eval do
      #   include InstanceMethods
      # end
    end

  end

  module InstanceMethods

    def translated_field_exists(field)
      self.class.translated_fields.member?(field.to_sym) && attributes.member?("#{field}_#{self.class.language}")
    end

    def translated_fields_to_attributes
      result = Array.new
      self.class.translated_fields.each do |field|
        attributes.each do |attribute, value|
          if attribute =~ /\A#{field}_\w{2}\Z/
            result << attribute
          end
        end
      end

      result.sort
    end

    def respond_to?(field, include_priv = false)
      return true if translated_field_exists(field)
      super
    end

    def method_missing(field, *args)
      return self["#{field}_#{self.class.language}".to_sym] if translated_field_exists(field)
      super
    end
  end
end