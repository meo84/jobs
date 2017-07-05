require 'date'
require_relative './car'

class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction

  def initialize(id, car_id, start_date, end_date, distance, deductible_reduction)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    raise ArgumentError, 'end_date must be later than start_date' if end_date < start_date

    raise ArgumentError, 'car_id must refer to the id of an existing car' if Car.find(car_id).nil?

    @id = id
    @car_id = car_id
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @deductible_reduction = deductible_reduction
  end

  def car
    Car.find(car_id)
  end

  def self.bills
    bills = ObjectSpace.each_object(Rental).map { |rental| rental.bill }
    bills.reverse
  end

  def bill
    {
      id: id,
      price: total_price.round,
      options: {
        deductible_reduction: deductible_charge
      },
      commission: commission_fees
    }
  end

  def total_price
    distance_price + time_price
  end

  def distance_price
    distance * car.price_per_km
  end

  def time_price
    time_price = 0
    for n in 0..number_of_days-1 do
      time_price += car.price_per_day * time_price_rate(n)
    end
    time_price
  end

  def number_of_days
    (end_date - start_date + 1).to_i
  end

  def time_price_rate(n)
    discounts = {
      10 => 0.5,
      4 => 0.3,
      1 => 0.1
    }
    discounts.each do |key, discount|
      return 1 - discount if n >= key
    end
    rate = 1
  end

  def commission_fees
    {
      insurance_fee: insurance_fee.round,
      assistance_fee: assistance_fee.round,
      drivy_fee: drivy_fee.round
    }
  end

  def commission
    0.3 * total_price
  end

  def insurance_fee
    0.5 * commission
  end

  def assistance_fee
    100 * number_of_days
  end

  def drivy_fee
    commission - insurance_fee - assistance_fee
  end

  def deductible_charge
    deductible_reduction ? 400 * number_of_days : 0
  end
end
