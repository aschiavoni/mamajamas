class GoogleContactsFetcher
  def initialize(google_authentication, app_id, secret_key, scope)
    @authentication = google_authentication
    @app_id = app_id
    @secret_key = secret_key
    @scope = scope
  end

  def contacts
    @contacts ||= get_contacts
  end

  private

  def authentication
    @authentication
  end

  def oauth
    @oauth_token ||= OAuth2::AccessToken.new(
      OAuth2::Client.new(@app_id, @secret_key, scope: @scope),
      authentication.access_token)
  end

  def get_contacts
    api = GoogleContactsApi::User.new(oauth)
    api.contacts.map do |contact|
      if contact.title.present? && contact.primary_email.present?
        {
          id: contact.id,
          name: contact.title,
          email: contact.primary_email,
          # photo_link: contact.photo_link,
          # photo: contact.photo
        }
      end
    end.reject { |c| c.blank? }
  end
end
