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

  def admin_page?
    admin_user? && params[:controller] =~ /^admin\//
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

  def nested_window?
    page_context.nested_window?
  end

  def show_header
    page_context.show_header
  end

  def show_mainnav
    page_context.show_mainnav
  end

  def skip_secondary_content?
    page_context.skip_secondary_content?
  end

  def body_id
    page_context.body_id
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

  def adwords_event(label, value)
    js = <<-JS
    <!-- Google Code for www.mamajamas.com/list Conversion Page -->
    <script type="text/javascript">
    /* <![CDATA[ */
    var google_conversion_id = 1014300698;
    var google_conversion_language = "en";
    var google_conversion_format = "2";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "#{label}";
    var google_conversion_value = #{value};
    var google_remarketing_only = false;
    /* ]]> */
    </script>
    <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
    </script>
    <noscript>
    <div style="display:inline;">
    <img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/1014300698/?value=#{value}&amp;label=#{label}&amp;guid=ON&amp;script=0"/>
    </div>
    </noscript>
    JS
    js.html_safe
  end

  def facebook_ad_conversion
    if Rails.env.production? && @facebook_ad_conversion_params
      js = <<-JS
        <!-- Facebook Conversion Code for Get to List Page -->
        <script>(function() {
        var _fbq = window._fbq || (window._fbq = []);
        if (!_fbq.loaded) {
        var fbds = document.createElement('script');
        fbds.async = true;
        fbds.src = '//connect.facebook.net/en_US/fbds.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(fbds, s);
        _fbq.loaded = true;
        }
        })();
        window._fbq = window._fbq || [];
        window._fbq.push(['track', '#{@facebook_ad_conversion_params[:pixel_id]}', {'value':'#{@facebook_ad_conversion_params[:value]}','currency':'#{@facebook_ad_conversion_params[:currency]}'}]);
        </script>
        <noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=#{@facebook_ad_conversion_params[:pixel_id]}&amp;cd[value]=#{@facebook_ad_conversion_params[:value]}&amp;cd[currency]=#{@facebook_ad_conversion_params[:currency]}&amp;noscript=1" /></noscript>
      JS
      js.html_safe
    end
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
