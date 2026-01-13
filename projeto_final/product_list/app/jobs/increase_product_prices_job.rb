class IncreaseProductPricesJob < ApplicationJob
  queue_as :default

  PRICE_INCREASE_PERCENTAGE = 0.10
  PRODUCTS_LIMIT = 10

  def perform
    products_to_update.each do |product|
      new_value = product.value * (1 + PRICE_INCREASE_PERCENTAGE)
      product.update!(value: new_value.round(2))
    end
  end

  private

  def products_to_update
    Product.order(:updated_at).limit(PRODUCTS_LIMIT)
  end
end
