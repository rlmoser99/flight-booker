# frozen_string_literal: true

class FlightConnections
  def initialize(params)
    @origin = params["origin_id"]
    @destination = params["destination_id"]
    @date = params["departure_date"]
  end

  def find_connections
    return if connecting_location? || close_location?

    first_leg = connecting_codes.collect { |code| find_first_leg(code) }
    all_connections = []
    first_leg.flatten(1).each do |leg|
      options = find_second_leg(leg)
      layover_start = leg.departure_time + (leg.duration.to_f / 60).hours + 1.hour
      layover_end = layover_start + 2.hours
      connecting_flights = [leg]
      options.each do |flight|
        connecting_flights << flight if flight.departure_time.between?(layover_start, layover_end)
      end
      all_connections << connecting_flights if connecting_flights.length > 1
    end
    all_connections
  end

  def find_first_leg(code)
    flight_options = Flight.where({ "origin_id" => @origin,
                                    "destination_id" => code,
                                    "departure_date" => @date })
    flight_options.to_a
  end

  def find_second_leg(first_leg)
    flight_options = Flight.where({ "origin_id" => first_leg.destination_id,
                                    "destination_id" => @destination,
                                    "departure_date" => @date })
    flight_options.to_a
  end

  def connecting_location?
    origin_airport = Airport.find_by(id: @origin).location
    destination_airport = Airport.find_by(id: @destination).location
    connecting_airports.include?(origin_airport) || connecting_airports.include?(destination_airport)
  end

  def close_location?
    origin_airport = Airport.find_by(id: @origin).location
    destination_airport = Airport.find_by(id: @destination).location
    close_airports.any? { |pair| pair == [origin_airport, destination_airport] }
  end

  def connecting_airports
    ["Atlanta, GA", "Chicago, IL", "Dallas, TX", "Denver, CO"]
  end

  def connecting_codes
    [3, 4, 6, 8]
  end

  def close_airports
    [
      ["San Francisco, CA", "Los Angeles, CA"],
      ["Los Angeles, CA", "San Francisco, CA"],
      ["New York City, NY", "Orlando, FL"],
      ["Orlando, FL", "New York City, NY"]
    ]
  end
end
