class Checkout

  def initialize(rules)
    @rules = rules
    @basket = {}
  end

  def scan(product)
    return unless product
    current_value = @basket[product.code].to_i
    @basket.merge!(product.code => current_value + 1)
  end

  def total
    (full_price - discount).round(2)
  end

  private

  def full_price
    @basket.inject(0) do |sum, (code, count)|
      sum + Products.by_code(code).price * count
    end
  end

  def discount
    @rules.inject(0) do |sum, rule_class|
      sum + rule_class.new(@basket).discount
    end
  end

end
