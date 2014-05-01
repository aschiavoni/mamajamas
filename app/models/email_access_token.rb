class EmailAccessToken
  def self.verifier
    ActiveSupport::MessageVerifier.
      new(Mamajamas::Application.config.secret_token)
  end

  # get uid and email name
  def self.read_access_token(signature)
    token = verifier.verify(signature)
    parts = token.split(":")
    { user_id: parts[0], email_name: parts[1] }
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def self.create_access_token(user, email_name)
    data = "#{user.id}:#{email_name}"
    verifier.generate(data)
  end
end
