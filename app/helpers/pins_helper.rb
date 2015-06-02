module PinsHelper
  def find_nearby_distance(latitude_longitude, restaurant)
    Geocoder::Calculations.distance_between(latitude_longitude, [restaurant.latitude, restaurant.longitude]).round(2)
  end

  def pin_distance
    Geocoder::Calculations.to_kilometers(@pin.distance_from([@latitude, @longitude])).round(2)
  end
end
