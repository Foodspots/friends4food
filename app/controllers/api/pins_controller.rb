class Api::PinsController < ApiController
	def sorted_by_distance
		pins = Pin.search(params[:search]).near([params[:latitude], params[:longitude]], 10000)

		paginate json: pins
	end

	def likes
		pins = Pin.where(:id => JSON.parse(params[:pins]))

		res = pins.map do |pin|
			{
				:id => pin.id,
				:likes => current_user.liked?(pin)
			}
		end

		render json: res
	end

	def friends_who_like
		pins = Pin.where(:id => JSON.parse(params[:pins]))

		res = pins.map do |pin|
			{
				:id => pin.id,
				:friends => ((current_user.followings || []) & (pin.votes_for.voters || []))
			}
		end

		render json: res
	end

	def like
		pin = Pin.find(params[:pin])
		pin.liked_by current_user

		render :nothing => true, :status => 201
	end
end

