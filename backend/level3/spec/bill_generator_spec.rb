require 'spec_helper'
require 'bill_generator'

RSpec.describe BillGenerator do

  let(:subject) { BillGenerator.new('data.json') }
  let(:output) { data_from_file('output.json') }

  describe '#checkout' do
    it 'saves bills into JSON output' do
      subject.checkout('output_level3.json')
      expect(data_from_file('output_level3.json')).to eql output
      File.delete('output_level3.json')
    end
  end
end
