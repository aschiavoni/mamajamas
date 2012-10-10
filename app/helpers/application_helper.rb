module ApplicationHelper
  # ability to use devise forms in all areas of the app
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping || Devise.mappings[:user]
  end

  def field_error(object, attribute)
    if object.errors[attribute].any?
      content_tag "strong", :class => "status-msg error" do
        object.errors[attribute].first
      end
    end
  end
end
