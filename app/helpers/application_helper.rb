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

  def admin_user?
    current_user && current_user.admin?
  end

  def user_has_list?
    current_user && current_user.list.present?
  end

  # flash notifications
  def notifications
    notifications = ""
    base_css_class = "notification"
    notification_config.each do |type, attribs|
      unless flash[type].blank?
        css_class = base_css_class
        css_class += " #{attribs[:css_class]}" unless attribs[:css_class].blank?
        notifications << content_tag(:p, :class => css_class) do
          content_tag(:strong, :class => "ss-icon") do
            attribs[:icon_name]
          end +
          flash[type]
        end
      end
    end
    notifications.html_safe
  end

  def page_id
    page_context.page_id
  end

  def subheader
    page_context.subheader
  end

  def preheader
    if page_context.preheader.present?
      content_tag :p, class: "prehed" do
        page_context.preheader
      end
    end
  end

  def show_header
    page_context.show_header
  end

  def show_mainnav
    page_context.show_mainnav
  end

  def body_class
    page_context.body_class
  end

  def tertiary_class
    page_context.tertiary_class
  end

  def pinnable?
    @pinterest_js == true
  end

  def pinterest_pin_url(options = {})
    query_params = options.slice(:url, :media, :description)
    query_params[:url] = default_share_url if query_params[:url].blank?
    "http://pinterest.com/pin/create/button/?#{query_params.to_query}"
  end

  def tweet_url(options = {})
    query_params = options.slice(:url, :text, :hashtags, :via)
    query_params[:url] = default_share_url if query_params[:url].blank?
    "https://twitter.com/share?#{query_params.to_query}"
  end

  def default_share_url
    request.original_url
  end

  private

  def notification_config
    @notification_config ||= {
      :notice => { :css_class => nil, :icon_name => "Info" },
      :alert => { :css_class => "n-alert", :icon_name => "Alert" },
      :success => { :css_class => "n-success", :icon_name => "Check" },
      :error => { :css_class => "n-error", :icon_name => "Caution" }
    }
  end
end
