require 'dry-initializer'
require './json_to_hash.rb'
require './commission.rb'
require './action.rb'
require 'date'

class Rental
  extend Dry::Initializer

  param :id, proc(&:to_i)
  param :car
  param :start_date, proc { |date| Date.parse(date) }
  param :end_date, proc { |date| Date.parse(date) }
  param :distance, proc(&:to_i)
  param :options
  param :price, default: proc { calculate_price.to_i }
  param :price_with_option, default: proc { calculate_price.to_i }
  param :commission, default: proc { calculate_commission }
  param :driver, default: proc { Action.new("driver", "debit", @price_with_option) }
  param :owner, default: proc { Action.new("owner", "credit", owner_price) }
  param :insurance, default: proc { Action.new("insurance", "credit", @commission.insurance_fee) }
  param :assistance, default: proc { Action.new("assistance", "credit", @commission.assistance_fee) }
  param :drivy, default: proc { Action.new("drivy", "credit", @commission.drivy_fee) }

  def owner_price
    price = @price * 0.7
    @options.each do | option |
      if option.type == "gps"
        price += 500 * days
      elsif option.type == "baby_seat"
        price += 200 * days
      end
    end
    price
  end

  def calculate_price
    @price = 0

    (1..days).each do | index |
      @price += @car.price_per_day * decrease_rate(index)
    end

    @price += @distance * car.price_per_km
    calculate_options
  end

  def calculate_options
    @price_with_option = @price
    @options.each do | option |
      if option.type == "gps"
        @price_with_option += 500 * days
      elsif option.type == "baby_seat"
        @price_with_option += 200 * days
      elsif option.type == "additional_insurance"
        @price_with_option += 1000 * days
      end
    end
    @price_with_option
  end

  def calculate_commission
    commission_price = @price * 0.3
    insurance_fee    = commission_price / 2
    assistance_fee   = days * 100
    drivy_fee        = insurance_fee - assistance_fee
    @options.each do | option |
      if option.type == "additional_insurance"
        drivy_fee += 1000 * days
      end
    end

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
    {
      "id": @id,
      "options": @options.map {|option| option.type},
      "actions": [
        @driver.to_json,
        @owner.to_json,
        @insurance.to_json,
        @assistance.to_json,
        @drivy.to_json
      ]
    }
  end

  def self.generate_from_json file, cars, options_raw
    rentals    = []
    input_data = JsonToHash.read_file file
    return rentals if input_data.nil?

    input_data["rentals"].each do | rental |
      car     = cars.detect{| car | car.id == rental["car_id"]}
      options = options_raw.select {| option| option.rental_id == rental["id"]}
      rentals << Rental.new(
        rental["id"],
        car,
        rental["start_date"],
        rental["end_date"],
        rental["distance"],
        options)
    end

    rentals
  end
end
