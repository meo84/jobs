class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end

  def self.find(id)
    cars = ObjectSpace.each_object(Car).select { |car| car.id == id }
    cars.first
  end
end
