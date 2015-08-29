namespace :email do
  desc 'Send email with top 3 visited restaurants last week to users'
  task weekly_gps_report: :environment do
  end

  desc 'Send email with top 3 liked restaurants last week to users'
  task weekly_friend_like_report: :environment do
  end

end
