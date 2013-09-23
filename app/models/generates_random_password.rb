class GeneratesRandomPassword
  def self.generate
    SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')[0, 20]
  end
end
