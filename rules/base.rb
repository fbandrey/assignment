module Rules
  class Base

    # Input is current basket
    def initialize(basket)
      @basket = basket
      @count = @basket[code].to_i
    end

    # Output is discount amount (EUR)
    def discount
      raise NotImplementedError
    end

    private

    def product
      @product ||= Products.by_code(code)
    end

    def code
      raise NotImplementedError
    end

  end
end
