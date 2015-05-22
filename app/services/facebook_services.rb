class FacebookServices
  def initialize(auth)
    @auth = auth
  end

  def follow_user_friends(current_user)
    access_token = Koala::Facebook::API.new(@auth[:credentials][:token])
    fb_friend_ids = access_token.get_connections('me', 'friends', fields: 'id')

    if fb_friend_ids.present?
      fb_friend_ids.each do |fb_friend_id|
        follow_facebook_friend(fb_friend_id['id'], current_user)
      end
    end
  end

  private

    def follow_facebook_friend(fb_friend_id, current_user)
      user = User.find_by(uid2: fb_friend_id)
      if user && !current_user.following?(user)
        begin
          current_user.follow!(user)
          ModelMailer.new_follower_notification(user, current_user).deliver
        rescue StandardError => e
          logger.error 'Something went wrong while following an user'
          logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
        end
      end
    end  
end