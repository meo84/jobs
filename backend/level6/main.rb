require './lib/bill_generator'

b = BillGenerator.new('data.json')
b.update_checkout('output_level6.json')
