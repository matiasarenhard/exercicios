require "csv"

module Products
  class CreateProductsCsv
    HEADERS = ["ID", "Name", "Description", "Value", "Quantity", "Available"].freeze
    BATCH_SIZE = 50

    def initialize(scope = Product.all)
      @scope = scope
    end

    def call
      Enumerator.new do |enum|
        enum << CSV.generate_line(HEADERS)

        @scope.find_each(batch_size: BATCH_SIZE) do |product|
          enum << CSV.generate_line([
            product.id,
            product.name,
            product.description,
            product.value,
            product.quantity,
            product.available
          ])
        end
      end
    end
  end
end
