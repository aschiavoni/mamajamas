class ReservedNameValidator < ActiveModel::EachValidator
  RESERVED_NAMES = %w{
    about account accounts add admin api app apps archive archives auth
    age ages age_range age_ranges
    blog
    categories category config connect contact create
    delete direct_messages downloads
    edit email
    faq favorites feed feeds fetch fetcher
    follow followers following friend friends
    help home
    invitations invite
    jobs
    list list_item list_items lists
    log-in log-out log_in log_out login logout logs
    map maps
    oauth oauth_clients omniauth omniauth_callbacks openid
    password passwords
    privacy product product_type product_types profile profiles
    quiz quizes
    register registrations relationship relationships remove replies robots rss
    save search searcher session sessions settings sign-in sign-out sign-up sign_in
    sign_out sign_up signin signout signup sitemap ssl subscribe
    terms test trends
    unfollow unsubscribe url user users
    when_to_buy when_to_buy_suggestions widget widgets
    xfn xmpp
  }

  def validate_each(object, attribute, value)
    if RESERVED_NAMES.include?(value)
      object.errors.add(attribute, :reserved_name)
    end
  end
end
