require 'geocoder'
require 'date'

class CTAInteractor
  def initialize(cta_wrapper)
    @cta_wrapper = cta_wrapper
  end

  def get_closest_stop(lat,long)
    shortest_distance = 0
    closest_stop = {}

    cta_wrapper.stops.each_with_index do |stop, index|
      current_distance = get_distance([lat, long], [stop[:lat],stop[:lon]])
      
      if(index == 0)
        shortest_distance = current_distance
        closest_stop = stop
      elsif current_distance < shortest_distance
        shortest_distance = current_distance
        closest_stop = stop
      end
    end

    closest_stop
  end

  def get_times_for_station(station_id)
    train_times = cta_wrapper.arrivals({query: {mapid: station_id}})

    train_times["ctatt"]["eta"].map do |train|
      destination = train["stpDe"]
      arrival_time = DateTime.parse(train["arrT"])
      arrival_string = arrival_time.strftime("%l:%M %p")

      "#{destination} coming at #{arrival_string}"
    end
  end

  private

  attr_reader :cta_wrapper

  def get_distance(point1, point2)
    Geocoder::Calculations.distance_between(point1, point2)
  end
end