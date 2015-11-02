namespace :email do
	desc 'Send email with top 3 visited restaurants last week to users'
	task weekly_gps_report: :environment do
		User.all.each do |u|
			most_visited = u.top_places_this_week
			next if most_visited.empty?

			ModelMailer.weekly_gps_report(u, most_visited).deliver
		end
	end

	desc 'Send email with top 3 liked restaurants last week to users'
	task weekly_friend_like_report: :environment do
		# For each user
		User.all.each do |u|
			# For each friend, grab the newly liked pins
			pins = u.followings.map do |friend|
				{:user => friend, :pins => friend.new_likes_this_week}
			end

			# Build a map pin => [user] that contains the users that have liked the pin in the last week
			ranking = Hash.new
			pins.each do |res|
				res[:pins].each do |pin|
					ranking[pin] = [] if ranking[pin].nil?
					ranking[pin] << res[:user]
				end
			end
			# Sort the map, turn it into an array
			ranking = ranking.sort_by do |pin, users|
				users.size
			end
			next if ranking.empty?

			ModelMailer.weekly_friend_like_report(u, ranking.take(3)).deliver
			puts "Sent to #{u.email}"
		end
	end
end
