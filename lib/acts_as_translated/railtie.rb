module ActsAsTranslated

  class Railtie < Rails::Railtie

    initializer 'acts_as_translated.insert_into_active_record' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsTranslated)
      end
    end

  end

end