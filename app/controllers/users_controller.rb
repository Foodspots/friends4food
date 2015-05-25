class UsersController < ApplicationController
	 before_action :authenticate_user!, except: [:index, :show]

	def show
		@user = User.find(params[:id])
		respond_to do |format|
		  format.html # show.html.erb
		  format.xml  { render :xml => @user }
		end
	end

	def index
	  @user = User.all.order("updated_at DESC")
	end

	def my_profile
	  @user = current_user
	end

	def my_friends
		@followings = current_user.followings
	end

	def followers
		@followers = current_user.followers.collect(&:user)
	end

	def feeds
    current_users_follower_pin_ids = []
    current_user.follows.each do |follower|
      current_users_follower_pin_ids << follower.followable.votes.pluck(:votable_id)
    end

    if params[:search_by_location]
      @latitude_longitude = Geocoder.coordinates(params[:search_by_location])
      @nearby_restaurants = Pin.near(@latitude_longitude, 10)
    end

    pins = Pin.find(current_users_follower_pin_ids.flatten.uniq)
    @pins = Kaminari.paginate_array(pins).page(params[:page]).per(RECORDS_PER_PAGE)
	end

end
