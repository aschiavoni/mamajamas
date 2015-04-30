class UserReferralIdGenerator
  def generate(user)
    converted = user.username.chars.map(&:ord).join + user.id.to_s
    hasher.encode(converted.to_i)
  end

  private

  def hasher
    @hasher ||= Hashids.new(salt)
  end

  def salt
    @salt ||= "mamajamas-#{Rails.env}-salted"
  end
end
