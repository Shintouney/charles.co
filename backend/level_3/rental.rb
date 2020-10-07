require 'dry-initializer'
require './json_to_hash.rb'
require './commission.rb'
require 'date'

class Rental
  extend Dry::Initializer

  param :id, proc(&:to_i)
  param :car
  param :start_date, proc { |date| Date.parse(date) }
  param :end_date, proc { |date| Date.parse(date) }
  param :distance, proc(&:to_i)
  param :price, default: proc { calculate_price.to_i }
  param :commission, default: proc { calculate_commission }

  def calculate_price
    @price = 0

    (1..days).each do | index |
      @price += @car.price_per_day * decrease_rate(index)
    end

    @price += @distance * car.price_per_km
  end

  def calculate_commission
    commission_price = @price * 0.3
    insurance_fee    = commission_price / 2
    assistance_fee   = days * 100
    drivy_fee        = insurance_fee - assistance_fee

    Commission.new insurance_fee, assistance_fee, drivy_fee
  end

  def days
    (@end_date - @start_date).to_i + 1
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

  def to_json
    { "id": @id, "price": @price, commission: @commission.to_json }
  end

  def self.generate_from_json file, cars
    rentals    = []
    input_data = JsonToHash.read_file file
    return rentals if input_data.nil?

    input_data["rentals"].each do | rental |
      car     = cars.detect{| car | car.id == rental["car_id"]}
      rentals << Rental.new(rental["id"], car, rental["start_date"], rental["end_date"], rental["distance"])
    end

    rentals
  end
end
