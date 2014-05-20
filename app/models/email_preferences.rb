module EmailPreferences
  extend ActiveSupport::Concern

  module ClassMethods
    def email_preference(name)
      sym = name.to_sym

      @email_preference_attrs ||= []
      @email_preference_attrs << sym
      class << self
        def email_preference_attributes
          @email_preference_attrs
        end
      end

      enabled_name = "#{sym}_enabled"
      disabled_name = "#{sym}_disabled"

      define_method disabled_name do
        # sometimes a string is store in the postgres json hash
        self.email_preferences &&
          self.email_preferences[disabled_name].present? &&
          self.email_preferences[disabled_name].to_s == "true"
      end

      define_method "#{disabled_name}?" do
        public_send(disabled_name)
      end

      define_method "#{disabled_name}=" do |val|
        self.email_preferences = (self.email_preferences || {}).
          merge(disabled_name => !!val)
      end

      define_method enabled_name do
        !public_send(disabled_name)
      end

      define_method "#{enabled_name}?" do
        !public_send("#{disabled_name}?")
      end

      define_method "#{enabled_name}=" do |val|
        public_send("#{disabled_name}=", !val)
      end

      define_method "unsubscribed_all?" do
        self.class.email_preference_attributes.map { |attr|
          public_send("#{attr}_enabled?")
        }.none?
      end
    end
  end
end
