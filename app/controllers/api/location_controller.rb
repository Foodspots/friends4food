class Api::LocationController < ApiController
  def create
	  pin = Pin.near([params[:latitude], params[:longitude]], Settings.app.tracking.distance, :units => :km).first

	  unless pin.nil?
		  # Log visit
	  end

	  render :json => {:location => pin}
  end
end
