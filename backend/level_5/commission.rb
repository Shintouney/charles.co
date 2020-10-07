require 'dry-initializer'
require './json_to_hash.rb'

class Commission
  extend Dry::Initializer

  param :insurance_fee, proc(&:to_i)
  param :assistance_fee, proc(&:to_i)
  param :drivy_fee, proc(&:to_i)

  def to_json
    {
      "insurance_fee": @insurance_fee,
      "assistance_fee": @assistance_fee,
      "drivy_fee": @drivy_fee
    }
  end
end
