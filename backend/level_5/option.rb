require 'dry-initializer'
require './json_to_hash.rb'

class Option
  extend Dry::Initializer

  param :id, proc(&:to_i)
  param :rental_id, proc(&:to_i)
  param :type, proc(&:to_s)

  def self.generate_from_json file
    options = []
    input_data = JsonToHash.read_file file
    return options if input_data.nil?

    input_data["options"].each do | option |
      options << Option.new(
        option["id"],
        option["rental_id"],
        option["type"]
      )
    end

    options
  end
end
