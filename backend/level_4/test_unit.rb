require './json_to_hash.rb'
require "test/unit"

class TestUnit < Test::Unit::TestCase

  def test_file_validity
    assert_equal("Hash", JsonToHash.read_file("input.json").class.name)
    assert_equal("Errno::ENOENT", JsonToHash.read_file("bad_input.json").class.name)
  end

  def test_rental
  end
end
