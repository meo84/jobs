require 'spec_helper'

describe FileIO do

    describe '.data_from_file' do
      it 'imports data from JSON file' do
        data = { cars: [], rentals: [] }
        File.open('read_test.json', 'w') { |file| file.write(JSON.pretty_generate(data)) }
        expect(data_from_file('read_test.json')).to eq data
        File.delete('read_test.json')
      end
    end

    describe '.save_to_file' do
      it 'writes data to JSON file' do
        data = ["rentals"]
        save_to_file(data, 'write_test.json')
        expect(data_from_file('write_test.json')).to eq data
        File.delete('write_test.json')
      end
    end

    describe '.get' do
      it 'returns object based on given ID' do
        car = { id: 1, price_per_day: 2000, price_per_km: 10 }
        data = data_from_file('data.json')
        expect(get(data, :cars, 1)).to eq car
      end
    end
end
