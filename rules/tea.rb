module Rules
  class Tea < Base

    def discount
      (@count / 2) * product.price
    end

    private

    def code
      'GR1'
    end

  end
end
