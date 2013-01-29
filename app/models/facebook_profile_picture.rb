class UnknownFacebookProfilePictureTypeException < Exception; end

class FacebookProfilePicture
  attr_reader :uid

  ALLOWED_TYPES = [ :square, :small, :normal, :large ]

  def initialize(uid, options = {})
    @uid = uid
    @options = default_options.merge(options)

    unless ALLOWED_TYPES.include?(@options[:type])
      raise UnknownFacebookProfilePictureTypeException
    end
  end

  def url
    url = "http://graph.facebook.com/#{uid}/picture?"
    if width.present? && height.present?
      url += "width=#{width}&height=#{height}"
    else
      url += "type=#{type}"
    end
  end

  def type
    @options[:type]
  end

  def width
    @options[:width]
  end

  def height
    @options[:height]
  end

  private

  def options
    @options
  end

  def default_options
    {
      type: :square
    }
  end
end
