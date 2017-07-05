require 'spec_helper'
require 'rental'

RSpec.describe Rental do

  before(:all) do
    ObjectSpace.garbage_collect
    @car = Car.new(1, 2000, 10)
    @rental = Rental.new(1, 1, "2015-12-8", "2015-12-8", 100, true)
  end

  describe 'creating rentals and associations' do
    describe '#initialize' do
      it 'raises an error if end_date is earlier than start_date' do
        expect { Rental.new(1, 1, "2015-12-10", "2015-12-8", 100, true) }.to raise_error ArgumentError, 'end_date must be later than start_date'
      end
      it 'raises an error if car_id doesn\`t exist' do
        expect { Rental.new(1, 2, "2015-12-8", "2015-12-8", 100, true) }.to raise_error ArgumentError, 'car_id must refer to the id of an existing car'
      end
    end

    describe '#car' do
      it 'returns car used for the rental' do
        expect(@rental.car).to eq @car
      end
    end
  end

  describe 'calculating rental price' do

    before(:all) do
      @rental = Rental.new(1, 1, "2017-12-8", "2017-12-10", 100, true)
    end

    describe '#distance_price' do
      it 'calculates the distance price component of a rental' do
        expect(@rental.distance_price).to eq 1000
      end
    end

    describe '#number_of_days' do
      it 'calculates the number of days of a rental' do
        expect(@rental.number_of_days).to eq 3
      end
    end

    describe '#time_price_rate' do
      it 'sets 90% price rate after 1 day' do
        expect(@rental.time_price_rate(1)).to eq 0.9
      end
      it 'sets 70% price rate after 4 days' do
        expect(@rental.time_price_rate(4)).to eq 0.7
      end
      it 'sets 50% price rate after 10 days' do
        expect(@rental.time_price_rate(10)).to eq 0.5
      end
      it 'sets full price rate for a day of rental' do
        expect(@rental.time_price_rate(0)).to eq 1
      end
    end

    describe '#time_price' do
      it 'calculates the degressive time price component of a rental' do
        expect(@rental.time_price).to eq 2000 + 0.9*2000 + 0.9*2000
      end
    end

    describe '#total_price' do
      it 'calculates the total price of a rental' do
        expect(@rental.total_price).to eq 6600
      end
    end
  end

  describe 'distributing commission fees' do

    describe '#commission' do
      it 'returns 30% of the total rental price' do
        expect(@rental.commission).to eq 900
      end
    end

    describe '#insurance_fee' do
      it 'returns half the commission fee' do
        expect(@rental.insurance_fee).to eq 450
      end
    end

    describe '#assistance_fee' do
      it 'charges 1 Euro for each day of rental' do
        expect(@rental.assistance_fee).to eq 100
      end
    end

    describe '#drivy_fee' do
      it 'returns the commission after insurance and assistance fee deduction' do
        expect(@rental.drivy_fee).to eq 350
      end
    end

    describe '#commission_fees' do
      it 'summarises the commission fees' do
        fees = {
          insurance_fee: 450,
          assistance_fee: 100,
          drivy_fee: 350
        }
        expect(@rental.commission_fees).to eq fees
      end
    end
  end

  describe 'options' do

    describe '#deductible_charge' do
      it 'charges 4 Euros for each day of rental when driver chose the the deductible option' do
        expect(@rental.deductible_charge).to eq 400
      end
    end
  end

  describe 'formatting rental bills' do

    before(:all) do
      ObjectSpace.garbage_collect
    end

    let(:output) { data_from_file('output.json') }
    let(:bill) { get(output, :rentals, 1) }

    describe '#bill' do
      it 'returns rental id and price' do
        expect(@rental.bill).to eql bill
      end
    end

    describe '.bills' do
      it 'returns all rental bills' do
        expect(Rental.bills).to eql [bill]
      end
    end
  end
end
