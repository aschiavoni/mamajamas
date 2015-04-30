class UserReferralIdGenerator
  def generate(user)
    converted = user.username.chars.map(&:ord).join.to_i
    hasher.encode(user.id + converted)
  end

  private

  def hasher
    @hasher ||= Hashids.new(salt)
  end

  def salt
    @salt ||= "mamajamas-#{Rails.env}-salted"
  end
end
