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

  def progress_id
    page_context.progress_id
  end

  def show_progress
    page_context.show_progress
  end

  def show_header
    page_context.show_header
  end

  def body_class
    page_context.body_class
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
