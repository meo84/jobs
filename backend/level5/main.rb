require './lib/bill_generator'

ObjectSpace.garbage_collect

b = BillGenerator.new('data.json')
b.checkout('output_level5.json')
