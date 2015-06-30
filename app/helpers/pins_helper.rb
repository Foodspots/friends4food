module PinsHelper
  def find_nearby_distance(latitude_longitude, restaurant)
    Geocoder::Calculations.distance_between(latitude_longitude, [restaurant.latitude, restaurant.longitude]).round(2)
  end

  def pin_distance(pin)
    if pin.geocoded? && @latitude.present? && @longitude.present?
      "#{Geocoder::Calculations.to_kilometers(pin.distance_from([@latitude, @longitude])).round(2)} km"
    end
  end

  def source_location
    Geocoder.search("#{@latitude}, #{@longitude}").map(&:formatted_address).first
  end

  def friends_who_liked_pin(pin)
    (current_user.followings || []) & (pin.votes_for.voters || [])
  end
end
