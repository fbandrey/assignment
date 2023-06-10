module Rules
  class Coffee < Base

    def discount
      return 0 if @count < 3
      product.price * @count / 3
    end

    private

    def code
      'CF1'
    end

  end
end
