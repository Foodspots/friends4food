class Api::LocationController < ApiController
  def create
	  pin = Pin.near([params[:latitude], params[:longitude]], Settings.app.tracking.distance, :units => :km).first

	  unless pin.nil?
		  Visit.create :pin => pin, :user => current_user
	  end

	  render :json => {:location => pin, :user => current_user}
  end
end
