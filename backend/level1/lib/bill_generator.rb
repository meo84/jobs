require_relative './file_io'
require 'json'
require 'date'

class BillGenerator
  include FileIO

  attr_accessor :data

  def initialize(input_file)
    @data = data_from_file(input_file)
  end

  def checkout(output_file)
    output = { rentals: bills }
    save_to_file(output, output_file)
  end

  def bills
    rentals = data[:rentals].map do |rental|
      car = get(data, :cars, rental[:car_id])
      bill(rental, car)
    end
  end

  def bill(rental, car)
    {
      id: rental[:id],
      price: total_price(rental, car)
    }
  end

  def total_price(rental, car)
    distance_price = distance_price(rental[:distance], car[:price_per_km])
    number_of_days = number_of_days(rental[:start_date], rental[:end_date])
    time_price = time_price(number_of_days, car[:price_per_day])
    distance_price + time_price
  end

  def distance_price(distance, price_per_km)
    distance * price_per_km
  end

  def time_price(number_of_days, price_per_day)
    number_of_days * price_per_day
  end

  def number_of_days(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    raise ArgumentError, 'end_date must be later than start_date' unless end_date >= start_date
    (end_date - start_date + 1).to_i
  end
end
