require 'acts_as_translated/version'


module ActsAsTranslated

  require 'acts_as_translated/railtie' if defined? Rails::Railtie

  def self.included(base)
    class << base
      attr_reader :cached_translated_attributes
    end

    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_translated(*args, default: :en)
      @cached_translated_attributes ||= []

      class_eval do
        args.each do |attribute|
          define_method attribute do
            self.class.acts_as_translated_attribute(self, attribute, I18n.locale, default: default)
          end
        end
      end
    end

    def acts_as_translated_attribute(object, name, locale, default: :en)
      attribute = "#{name}_#{locale}".to_sym

      if @cached_translated_attributes.member?(attribute)
        return object.send attribute
      end

      if object.respond_to? attribute
        @cached_translated_attributes << attribute
        return object.send attribute
      else
        return object.send "#{name}_#{default}".to_sym
      end
    end

  end

end