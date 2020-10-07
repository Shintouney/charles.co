#!/usr/bin/env ruby
require './car.rb'
require './rental.rb'
require './option.rb'
require './json_to_hash.rb'

def main
  cars    = Car.generate_from_json "input.json"
  options = Option.generate_from_json "input.json"
  rentals = Rental.generate_from_json "input.json", cars, options
  JsonToHash.write_output("rentals": rentals.map { | rental | rental.to_json })
end

main
