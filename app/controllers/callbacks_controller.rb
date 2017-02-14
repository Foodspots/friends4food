class CallbacksController < Devise::OmniauthCallbacksController
	def facebook
		@user = User.from_omniauth(request.env["omniauth.auth"])
		if @user.persisted?
			sign_in @user, :event => :authentication #this will throw if @user is not activated
			redirect_to '/welcome'
		else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to '/home'
		end
	end
end
