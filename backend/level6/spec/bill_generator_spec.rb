require 'spec_helper'
require 'bill_generator'

RSpec.describe BillGenerator do

  before { ObjectSpace.garbage_collect }
  let(:subject) { BillGenerator.new('data.json') }
  let(:output) { data_from_file('output.json') }

  describe '#checkout' do
    it 'saves bills into JSON output' do
      subject.update_checkout('output_level6.json')
      expect(data_from_file('output_level6.json')).to eql output
      File.delete('output_level6.json')
    end
  end
end
