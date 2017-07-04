require './lib/bill_generator'

b = BillGenerator.new('data.json')
b.checkout('output_level2.json')
