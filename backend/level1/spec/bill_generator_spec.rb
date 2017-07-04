require 'spec_helper'
require 'bill_generator'

RSpec.describe BillGenerator do

  let(:subject) { BillGenerator.new('data.json') }
  let(:output) { data_from_file('output.json') }

  describe 'calculating rental price' do

    describe '#distance_price' do
      it 'calculates the distance price component of a rental' do
        distance = 100
        price_per_km = 10
        expect(subject.distance_price(distance, price_per_km)).to eq 1000
      end
    end

    describe '#number_of_days' do
      it 'calculates the number of days of a rental' do
        expect(subject.number_of_days("2017-12-8", "2017-12-10")).to eq 3
      end

      it 'raises an error if end_date is earlier than start_date' do
        expect { subject.number_of_days("2017-12-10", "2017-12-8") }.to raise_error ArgumentError, 'end_date must be later than start_date'
      end
    end

    describe '#time_price' do
      it 'calculates the time price component of a rental' do
        number_of_days = 3
        price_per_day = 2000
        expect(subject.time_price(number_of_days, price_per_day)).to eq 6000
      end
    end

    describe '#total_price' do
      it 'calculates the total price of a rental' do
        rental = get(subject.data, :rentals, 1)
        car = get(subject.data, :cars, rental[:car_id])
        price = get(output, :rentals, 1)[:price]
        expect(subject.total_price(rental, car)).to eq price
      end
    end
  end

  describe 'formatting rental bill' do

    describe '#bill' do
      it 'returns rental id and price' do
        rental = get(subject.data, :rentals, 1)
        car = get(subject.data, :cars, rental[:car_id])
        bill = get(output, :rentals, 1)
        expect(subject.bill(rental, car)).to eq bill
      end
    end

    describe '#bills' do
      it 'returns all rental bills' do
        expect(subject.bills).to eq output[:rentals]
      end
    end

    describe '#checkout' do
      it 'saves bills into JSON output' do
        subject.checkout('output_level1.json')
        expect(data_from_file('output_level1.json')).to eq output
        File.delete('output_level1.json')
      end
    end
  end
end
