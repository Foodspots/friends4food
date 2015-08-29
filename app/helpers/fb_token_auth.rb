class FBTokenAuth
	class Info
		attr_reader :uid
		attr_reader :email
		attr_reader :name

		def initialize (uid, email, name)
			@uid = uid
			@email = email
			@name = name
		end

		def image
			"http://graph.facebook.com/#{@uid}/picture?type=square"
		end

		def self.from_hash(hash)
			Info.new hash['id'], hash['email'], hash['name']
		end
	end

	attr_reader :uid
	attr_reader :info

	def initialize (uid, info, token)
		@uid = uid
		@info = info
		@token = token
	end

	def provider
		'facebook'
	end

	# Simple [] definition so that auth[:credentials][:token] works for FacebookServices
	def [](key)
		{
			:token => @token
		}
	end

	def self.from_token (token)
		info = Info.from_hash(JSON.parse(CurbFu.get("https://graph.facebook.com/me?fields=email,name&access_token=#{token}").body))
		return nil if info.uid.nil?
		FBTokenAuth.new info.uid, info, token
	end
end
