require 'ostruct'

module Products
  LIST = [
    OpenStruct.new(
      name: 'Green tea',
      code: 'GR1',
      price: 3.11,
    ),
    OpenStruct.new(
      name: 'Strawberry',
      code: 'SR1',
      price: 5.00,
    ),
    OpenStruct.new(
      name: 'Coffee',
      code: 'CF1',
      price: 11.23,
    ),
  ]

  def self.by_code(code)
    LIST.find { |pr| pr.code == code }
  end

end
