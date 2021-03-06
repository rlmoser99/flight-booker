# frozen_string_literal: true

class FlightGenerator
  def initialize(date)
    @date = date
  end

  def call
    airport_pairs = find_airport_pairs
    airport_pairs.each do |airport_pair|
      find_or_create_flights(airport_pair)
    end
  end

  private

    # Using guard clause instead of #find_or_create_by due to using random departure times
    def find_or_create_flights(airport_pair)
      origin = Airport.find_by(code: airport_pair[0])
      destination = Airport.find_by(code: airport_pair[1])
      flights = Flight.where(origin_airport: origin, destination_airport: destination, departure_date: @date)
      return if flights.count.positive?

      flight_duration = find_flight_duration(airport_pair)
      create_flights(origin, destination, flight_duration)
    end

    def create_flights(origin, destination, flight_duration)
      departure_times = [morning_time, afternoon_time, evening_time]
      departure_times.each do |departure_time|
        Flight.create(origin_airport: origin,
                      destination_airport: destination,
                      departure_date: @date,
                      departure_time: departure_time,
                      duration: flight_duration)
      end
    end

    def flight_duration
      {
        SFO: { NYC: 308, ATL: 257, ORD: 224, LAX: 53, DFW: 181, MCO: 292, DEN: 125 },
        NYC: { SFO: 308, ATL: 101, ORD: 99, LAX: 296, DFW: 173, MCO: 122, DEN: 199 },
        ATL: { SFO: 257, NYC: 101, ORD: 84, LAX: 236, DFW: 98, MCO: 61, DEN: 151 },
        ORD: { SFO: 224, NYC: 99, ATL: 84, LAX: 213, DFW: 106, MCO: 129, DEN: 116 },
        LAX: { SFO: 53, NYC: 296, ATL: 236, ORD: 213, DFW: 155, MCO: 266, DEN: 113 },
        DFW: { SFO: 181, NYC: 173, ATL: 98, ORD: 106, LAX: 155, MCO: 127, DEN: 88 },
        MCO: { SFO: 292, NYC: 122, ATL: 61, ORD: 129, LAX: 266, DFW: 127, DEN: 190 },
        DEN: { SFO: 125, NYC: 199, ATL: 151, ORD: 116, LAX: 113, DFW: 88, MCO: 190 }
      }
    end

    def find_flight_duration(airports)
      flight_duration[airports[0].to_sym][airports[1].to_sym]
    end

    def find_airport_pairs
      flight_duration.keys.map(&:to_s).permutation(2)
    end

    def morning_time
      Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :morning)
    end

    def afternoon_time
      Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :afternoon)
    end

    def evening_time
      Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :evening)
    end
end
