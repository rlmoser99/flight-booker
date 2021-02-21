# frozen_string_literal: true

class BookingOptions
  def initialize(params)
    @origin = Airport.find_by(id: params[:origin_id])
    @destination = Airport.find_by(id: params[:destination_id])
    @date = params["departure_date"]
  end

  def find_flights
    direct_flights = find_flight_options(@origin, @destination, @date).collect { |flight| [flight] }
    return direct_flights if layover_location? || direct_flight_locations?

    direct_flights + find_connecting_flights
  end

  private

    def find_connecting_flights
      first_leg_options = layover_codes.collect do |code|
        connecting_airport = Airport.where(code: code)
        find_flight_options(@origin, connecting_airport, @date)
      end.flatten(1).uniq
      first_leg_options.map do |first_leg|
        find_second_leg_options(first_leg)
      end.compact
    end

    def find_second_leg_options(leg)
      flight_options = find_flight_options(leg.destination_airport, @destination, @date)
      layover_start = leg.departure_time + (leg.duration.to_f / 60).hours + 1.hour
      second_leg = find_flights_within_layover_time(flight_options, layover_start)
      return unless second_leg

      [leg, second_leg]
    end

    def find_flights_within_layover_time(options, layover_start)
      layover_end = layover_start + 2.hours
      connecting_flight = options.select do |flight|
        flight.departure_time.between?(layover_start, layover_end)
      end
      connecting_flight&.first
    end

    def find_flight_options(origin, destination, date)
      Flight.where({ "origin_id" => origin,
                     "destination_id" => destination,
                     "departure_date" => date })
    end

    def layover_location?
      layover_codes.include?(@origin.code) || layover_codes.include?(@destination.code)
    end

    # Airport ID's for Atlanta, Chicago, Dallas, and Denver
    def layover_codes
      %w[ATL ORD DFW DEN]
    end

    def direct_flight_locations?
      direct_flight_codes.any? { |pair| pair == [@origin.code, @destination.code] }
    end

    # Flights to & from San Francisco/Los Angeles and New York City/Orlando
    def direct_flight_codes
      [
        %w[SFO LAX], %w[LAX SFO], %w[NYC MCO], %w[MCO NYC]
      ]
    end
end
