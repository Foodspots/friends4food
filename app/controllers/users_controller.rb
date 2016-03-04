class UsersController < ApplicationController
  
	def show
		@user = User.find(params[:id])
		@pins = Kaminari.paginate_array(@user.find_liked_items).page(params[:page]).per(RECORDS_PER_PAGE)
		render locals: {current_user: current_user}
	end

	def index
	  @user = User.all.order("updated_at DESC").select do |u|
		  not (u == current_user or current_user.following?(u))
	  end
	  render locals: {current_user: current_user}
	end

	def my_profile
		@user = current_user
		@pins = Kaminari.paginate_array(@user.find_liked_items).page(params[:page]).per(RECORDS_PER_PAGE)
		respond_to do |format|
			format.html {render locals: {current_user: current_user}}
			format.js {render 'pins/addnextpage', locals: {current_user: current_user}}
		end
	end	

	def my_friends
		@followings = current_user.followings
		render locals: {current_user: current_user}
	end

	def welcome
		@user = current_user
		@welcomed = @user.welcomed
		if not @welcomed
			# User is new
			@user.welcomed = true
			@user.save!
		else
			# Existing user, check if we can skip the location share page
			unless @latitude.nil? and @longitude.nil?
				redirect_to root_url
			end
		end
	end

	def home
		@user = current_user
		@welcomed = @user.welcomed
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

	def my_recently_visited
		@user = current_user
	end
end
