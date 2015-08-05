class GravatarProfilePicture
  GRAVATAR_HOST = "www.gravatar.com"
  SECURE_GRAVATAR_HOST = "secure.gravatar.com"

  def self.url(email, size = 86)
    generate_url(email, size, false)
  end

  def self.secure_url(email, size = 86)
    generate_url(email, size, true)
  end

  def self.default_url
    "http://mamajamas.s3.amazonaws.com/assets/profile_photo-default-l.png"
  end

  private

  def self.generate_url(email, size, secure = false)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    url = secure ? "https://#{SECURE_GRAVATAR_HOST}" : "http://#{GRAVATAR_HOST}"
    url += "/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}"
  end
end
