class ApiController < ActionController::Base
	include ApiAuthHelper

	before_filter :require_login

	private
	def require_login
		unless current_user
			render status: :unauthorized, file: 'api/unauthorized.txt', content_type: 'text/plain'
		end
	end
end
