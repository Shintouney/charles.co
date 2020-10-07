require './json_to_hash.rb'
require './rental.rb'
require './car.rb'
require "test/unit"

class TestUnit < Test::Unit::TestCase

  def test_file_validity
    assert_equal("Hash", JsonToHash.read_file("input.json").class.name)
    assert_equal("Errno::ENOENT", JsonToHash.read_file("bad_input.json").class.name)
  end

  def test_rental_price
    rental = Rental.new(1, Car.new(1, 2000, 10), "2015-03-31", "2015-04-01", 300)

    assert_equal(6800, rental.driver.amount)
    assert_equal(4760, rental.owner.amount)
  end

  def test_rental_commission
    rental = Rental.new(1, Car.new(1, 2000, 10), "2015-03-31", "2015-04-01", 300)
    assert_equal(1020, rental.commission.insurance_fee)
    assert_equal(200, rental.commission.assistance_fee)
    assert_equal(820, rental.commission.drivy_fee)
  end
end
