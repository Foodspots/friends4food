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
	end
end
