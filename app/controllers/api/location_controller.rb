class Api::LocationController < ApiController
  def create
	  current_user.checkin params[:latitude], params[:longitude]

	  render :json => {}
  end
end
