require 'dry-initializer'
require './json_to_hash.rb'

class Action
  extend Dry::Initializer
  param :who, proc(&:to_s)
  param :type_action, proc(&:to_s)
  param :amount, proc(&:to_i)

  def to_json
    { "who": @who, "type": @type_action, amount: @amount }
  end
end
