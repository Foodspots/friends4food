class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success) if is_navigational_format?
      follow_user_friends(request.env["omniauth.auth"])
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def follow_user_friends(auth)
    access_token = Koala::Facebook::API.new(auth[:credentials][:token])
    fb_friend_ids = access_token.get_connections("me", "friends", fields: "id")

    if fb_friend_ids.present?
      fb_friend_ids.each do |fb_friend_id|
        find_create_send_notification_to_followers(fb_friend_id['id'])
      end
    end
  end

  def find_create_send_notification_to_followers(friend_id)
    user = User.find_by_uid2(friend_id)
    if user && !current_user.following?(user)
      current_user.follow!(user)
      begin
        ModelMailer.new_follower_notification(user, current_user).deliver
      rescue StandardError => e
        logger.error 'Unable to send new follower notification'
        logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
      end
    end
  end
end