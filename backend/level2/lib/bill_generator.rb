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
      price: total_price(rental, car).round
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
    time_price = 0
    for n in 0..number_of_days-1 do
      time_price += price_per_day * time_price_rate(n)
    end
    time_price
  end

  def number_of_days(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    raise ArgumentError, 'end_date must be later than start_date' unless end_date >= start_date
    (end_date - start_date + 1).to_i
  end

  def time_price_rate(number_of_days)
    discounts = {
      10 => 0.5,
      4 => 0.3,
      1 => 0.1
    }
    discounts.each do |key, discount|
      return 1 - discount if number_of_days >= key
    end
    rate = 1
  end
end
