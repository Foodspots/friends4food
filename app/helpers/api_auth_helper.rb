module ApiAuthHelper
	def find_user
		auth = FBTokenAuth.from_token request.headers['Authorization']
		return nil if auth.nil?
		User.from_omniauth auth
	end

	def current_user
		@current_user ||= find_user
	end

	def signed_in?
		!current_user.nil?
	end
end
