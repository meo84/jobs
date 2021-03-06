require 'json'
require 'date'
require_relative './file_io'
require_relative './car'
require_relative './rental'

class BillGenerator
  include FileIO

  attr_accessor :data

  def initialize(input_file)
    @data = data_from_file(input_file)
    create_cars
    create_rentals
  end

  def create_cars
    data[:cars].each do |car|
      Car.new(
        car[:id],
        car[:price_per_day],
        car[:price_per_km])
    end
  end

  def create_rentals
    data[:rentals].each do |rental|
      Rental.new(
        rental[:id],
        rental[:car_id],
        rental[:start_date],
        rental[:end_date],
        rental[:distance],
        rental[:deductible_reduction]
      )
    end
  end

  def checkout(output_file)
    output = { rentals: Rental.bills }
    save_to_file(output, output_file)
  end

end
