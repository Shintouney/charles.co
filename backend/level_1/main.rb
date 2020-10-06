#!/usr/bin/env ruby
require "date"
require "json"
require "awesome_print"

def json_to_hash filename
  file = File.read filename
  JSON.parse file
end

def generate_data data:
  output            = {}
  output["rentals"] = []

  data["rentals"].each do | rental |
    start_date = Date.parse rental["start_date"]
    end_date   = Date.parse rental["end_date"]
    days       = (end_date - start_date).to_i + 1
    car        = data["cars"].detect { |car| car["id"] == rental["car_id"] }
    price      = days * car["price_per_day"] + rental["distance"] * car["price_per_km"]
    output["rentals"] << { "id": rental["id"], "price": price }
  end
  ap output
end

def main
  input_data  = json_to_hash "input.json"
  output_data = generate_data data: input_data
  File.open("output.json", "w") do |file|
    file.write(JSON.pretty_generate(output_data))
  end
end

main
