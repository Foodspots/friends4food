module PinsHelper
  def find_nearby_distance(latitude_longitude, restaurant)
    Geocoder::Calculations.distance_between(latitude_longitude, [restaurant.latitude, restaurant.longitude]).round(2)
  end

  def pin_distance(pin)
    Rails.logger.info "pin_distance>>>>>>>>>>>>> Pin : #{pin.id} - #{pin.name}"
    Rails.logger.info "pin_distance>>>>>>>>>>>>> Co-ordinates : #{[@latitude, @longitude]}"
    if @latitude.present? && @longitude.present?
      "#{Geocoder::Calculations.to_kilometers(pin.distance_from([@latitude, @longitude])).round(2)} km"
    end
  end
end
