class UsersController < ApplicationController
  
	def show
		@user = User.find(params[:id])
		render locals: {current_user: current_user}
	end

	def index
	  @user = User.all.order("updated_at DESC")
	  render locals: {current_user: current_user}
	end

	def my_profile
		@user = current_user
	end	

	def my_friends
		render locals: {current_user: current_user}
	end

	def followers
		@followers = current_user.followers.collect(&:user)
	end

	def feeds
		current_users_follower_pin_ids = []
		current_user.follows.each do |follower|
			if follower.followable.present?
				current_users_follower_pin_ids << follower.followable.votes.pluck(:votable_id)
			end
		end
    
    	pins = Pin.find(current_users_follower_pin_ids.flatten.uniq)
    	@pins = Kaminari.paginate_array(pins).page(params[:page]).per(RECORDS_PER_PAGE)
	end

end
