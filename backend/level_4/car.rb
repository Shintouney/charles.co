require 'dry-initializer'
require './json_to_hash.rb'

class Car
  extend Dry::Initializer

  param :id, proc(&:to_i)
  param :price_per_day, proc(&:to_i)
  param :price_per_km, proc(&:to_i)

  def self.generate_from_json file
    cars       = []
    input_data = JsonToHash.read_file file
    return cars if input_data.nil?

    input_data["cars"].each do | car |
      cars << Car.new(car["id"], car["price_per_day"], car["price_per_km"])
    end

    cars
  end
end
