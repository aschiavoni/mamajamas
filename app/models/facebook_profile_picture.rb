# indicates the type of profile picture is not recognized
class FacebookUnknownProfilePictureTypeException < Exception; end
# indicates the facebook uid is nil
class FacebookUidNilException < Exception; end

# encapsulates facebook profile pictures
class FacebookProfilePicture
  attr_reader :uid

  ALLOWED_TYPES = [ :square, :small, :normal, :large ]

  def initialize(uid, options = {})
    raise FacebookUidNilException if uid.blank?

    @uid = uid
    @options = default_options.merge(options)

    unless ALLOWED_TYPES.include?(@options[:type])
      raise FacebookUnknownProfilePictureTypeException
    end
  end

  def url
    url = "https://graph.facebook.com/#{uid}/picture?"
    url += dimensions_specified? ? dimensions_query_string : type_query_string
    url
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

  def dimensions_specified?
    width.present? && height.present?
  end

  def dimensions_query_string
    "width=#{width}&height=#{height}"
  end

  def type_query_string
    "type=#{type}"
  end
end
