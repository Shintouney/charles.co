#!/usr/bin/env ruby
require "date"
require "json"
require "awesome_print"

def json_to_hash filename
  file = File.read filename
  JSON.parse file
end

def nb_days rental
  start_date = Date.parse rental["start_date"]
  end_date   = Date.parse rental["end_date"]
  (end_date - start_date).to_i + 1
end

def decrease_rate rate
  if rate <= 1
    1
  elsif rate > 1 && rate <= 4
    0.9
  elsif rate > 4 && rate <= 10
    0.7
  else
    0.5
  end
end

def calculate_price rental, car
  days  = nb_days(rental)
  price = 0

  for index in 1..days
    price += car["price_per_day"] * decrease_rate(index)
  end
  price += rental["distance"] * car["price_per_km"]
  price.to_i
end

def generate_data data:
  output            = {}
  output["rentals"] = []

  data["rentals"].each do | rental |
    car   = data["cars"].detect { |car| car["id"] == rental["car_id"] }
    price = calculate_price(rental, car)
    output["rentals"] << { "id": rental["id"], "price": price }
  end
  output
end

def main
  input_data  = json_to_hash "input.json"
  output_data = generate_data data: input_data
  File.open("output.json", "w") do |file|
    file.write(JSON.pretty_generate(output_data))
  end
end

main
