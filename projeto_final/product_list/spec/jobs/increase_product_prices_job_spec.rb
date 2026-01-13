require "rails_helper"

RSpec.describe IncreaseProductPricesJob, type: :job do
  subject(:job) { described_class.new }

  describe "queue" do
    it "uses the default queue" do
      expect(described_class.queue_name).to eq("default")
    end
  end

  describe "#perform" do
    let!(:older_products) do
      create_list(:product, 10, value: 100.0, updated_at: 2.days.ago)
    end

    let!(:newer_products) do
      create_list(:product, 5, value: 100.0, updated_at: 1.hour.ago)
    end

    it "increases the price by 10% for the oldest products only" do
      job.perform

      older_products.each do |product|
        expect(product.reload.value).to eq(110.0)
      end

      newer_products.each do |product|
        expect(product.reload.value).to eq(100.0)
      end
    end

    it "rounds values to two decimal places" do
      product = create(:product, value: 99.999, updated_at: 5.days.ago)

      create_list(:product, 9, value: 100, updated_at: 4.days.ago)

      job.perform

      expect(product.reload.value).to eq(110.0)
    end
  end
end