require './lib/bill_generator'

b = BillGenerator.new('data.json')
b.checkout('output_level1.json')
