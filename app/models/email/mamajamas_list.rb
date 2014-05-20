module Email
  class MamajamasList
    DEFAULT_LIST_NAME = "Mamajamas Development"
    DEFAULT_INTEREST_GROUPING_NAME = "Preferences"
    PREFERENCES_GROUPS = %w(Blog Product)

    def self.configure
      list = Email::List.find(list_name)
      list.add_interest_grouping(interest_grouping_name, PREFERENCES_GROUPS)
    end

    def initialize
      @list = Email::List.find(self.class.list_name)
    end

    def subscribe(user, groups = PREFERENCES_GROUPS)
      merge_vars = {
        fname: user.first_name,
        lname: user.last_name,
        groupings: [
                    {
                      name: self.class.interest_grouping_name,
                      groups: groups
                    }
                   ]
      }

      @list.subscribe(user.email, merge_vars,
                      double_optin: false,
                      update_existing: true,
                      send_welcome: false)
    end

    def unsubscribe(user)
      unsubscribe_email(user.email)
    end

    def unsubscribe_email(email)
      @list.unsubscribe(email, send_goodbye: false, send_notify: true)
    end

    def subscribed
      @list.members
    end

    def unsubscribed
      @list.members(:unsubscribed)
    end

    private

    def self.list_name
      ENV['MAILCHIMP_MAILING_LIST_NAME'] || DEFAULT_LIST_NAME
    end

    def self.interest_grouping_name
      ENV['MAILCHIMP_MAILING_LIST_GROUPING'] || DEFAULT_INTEREST_GROUPING_NAME
    end
  end
end
