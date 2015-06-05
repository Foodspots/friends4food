class FacebookServices
  def initialize(auth)
    @auth = auth
  end

  def follow_fb_friends(current_user)
    puts "=========================== FacebookServices :: follow_fb_friends ==================="
    access_token = Koala::Facebook::API.new(@auth[:credentials][:token])
    fb_friend_ids = access_token.get_connections('me', 'friends', fields: 'id')
    puts "follow_fb_friends =====>>>>>>> #{current_user.email} Friends - #{fb_friend_ids}"
    if fb_friend_ids.present?
      fb_friend_ids.each do |fb_friend_id|
        follow_fb_friend(fb_friend_id['id'], current_user)
      end
    end
  end

  def follow_fb_friend(fb_friend_id, current_user, bidirectional = true)
    puts "fb_friend_id: #{fb_friend_id} <==> current_user.id: #{current_user.id}"
    user = User.find_by(uid2: fb_friend_id)
    if user && !current_user.following?(user)
      begin
        User.transaction do
          current_user.follow!(user)
          user.follow!(current_user) if bidirectional
        end
        ModelMailer.new_follower_notification(user, current_user).deliver
      rescue StandardError => e
        Rails.logger.error 'Something went wrong while following an user'
        Rails.logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
      end
    end
  end  
end