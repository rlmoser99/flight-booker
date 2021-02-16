# frozen_string_literal: true

class BookingOptions
  def initialize(params)
    @origin = params["origin_id"].to_i
    @destination = params["destination_id"].to_i
    @date = params["departure_date"]
  end

  def find_flights
    direct_flights = find_direct_flights.collect { |flight| [flight] }
    direct_flights + find_connecting_flights
  end

  def find_connecting_flights
    return if layover_location? || direct_flight_locations?

    first_leg_possibilities = layover_codes.collect { |code| find_first_leg(code) }.flatten(1)
    first_leg_possibilities.map do |first_leg|
      find_connecting_possibilities(first_leg)
    end.compact
  end

  private

    def find_connecting_possibilities(leg)
      options = find_second_leg(leg)
      layover_start = leg.departure_time + (leg.duration.to_f / 60).hours + 1.hour
      layover_end = layover_start + 2.hours
      second_leg = options.select do |flight|
        flight.departure_time.between?(layover_start, layover_end)
      end
      [leg, second_leg.first] unless second_leg.empty?
    end

    def find_direct_flights
      Flight.where({ "origin_id" => @origin,
                     "destination_id" => @destination,
                     "departure_date" => @date })
    end

    def find_first_leg(code)
      Flight.where({ "origin_id" => @origin,
                     "destination_id" => code,
                     "departure_date" => @date })
    end

    def find_second_leg(first_leg)
      Flight.where({ "origin_id" => first_leg.destination_id,
                     "destination_id" => @destination,
                     "departure_date" => @date })
    end

    def layover_location?
      layover_codes.include?(@origin) || layover_codes.include?(@destination)
    end

    # Airport ID's for Atlanta, Chicago, Dallas, and Denver
    def layover_codes
      [3, 4, 6, 8]
    end

    def direct_flight_locations?
      direct_flight_codes.any? { |pair| pair == [@origin, @destination] }
    end

    # Flights to & from San Francisco/Los Angeles and New York City/Orlando
    def direct_flight_codes
      [
        [1, 5], [5, 1], [2, 7], [7, 2]
      ]
    end
end
