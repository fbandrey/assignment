module Rules
  class Strawberry < Base
    DISCOUNT_PRICE = 4.5

    def discount
      return 0 if @count < 3
      (product.price - DISCOUNT_PRICE) * @count
    end

    private

    def code
      'SR1'
    end

  end
end
