module Email
  class List < Base
    def self.all
      api.lists.list["data"].map { |l| List.new(l) }
    end

    def self.find(name)
      results = api.lists.list({ filters: { list_name: name } })
      return nil if results.blank? || results["total"] == 0

      List.new(results["data"].select { |l|
                 l["name"].downcase == name.downcase
               }.first)
    end

    def initialize(list)
      @list = list.deep_symbolize_keys
    end

    def id
      list[:id]
    end

    def members(status = nil)
      api.lists.members(id: id, status: status)
    end

    def interest_groupings
      api.lists.interest_groupings(id: id)
    end

    def add_interest_grouping(name, groups = [], type = :hidden)
      api.lists.interest_grouping_add(id: id,
                                      name: name,
                                      type: type.to_s,
                                      groups: groups)
    end

    def subscribe(email, merge_vars = {}, options = {})
      double_optin = options.fetch(:double_optin, true)
      update = options.fetch(:update_existing, false)
      replace_interests = options.fetch(:replace_interests, true)
      send_welcome = options.fetch(:send_welcome, false)
      email_type = options.delete(:email_type) == :text ? :text : :html

      params = {
        id: self.id,
        email: { email: email },
        merge_vars: merge_vars,
        double_optin: double_optin,
        email_type: email_type.to_s,
        update_existing: update,
        replace_interests: replace_interests,
        send_welcome: send_welcome
      }

      api.lists.subscribe(params)
    end

    def unsubscribe(email, options = {})
      delete_member = options.fetch(:delete_member, false)
      send_goodbye = options.fetch(:send_goodbye, true)
      send_notify = options.fetch(:send_notify, true)

      params = {
        id: id,
        email: { email: email },
        delete_member: delete_member,
        send_goodbye: send_goodbye,
        send_notify: send_notify
      }

      begin
        api.lists.unsubscribe(params)
      rescue Gibbon::MailChimpError => e
        raise e unless e.name == "List_NotSubscribed"
      end
    end

    private

    def list
      @list
    end
  end
end
