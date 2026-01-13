require 'rails_helper'

RSpec.describe Products::CreateProductsCsv do
  describe '#call' do
    let!(:product) { create(:product, name: 'Test Product', value: 99.99) }

    it 'returns an Enumerator with CSV headers and product data' do
      result = described_class.new.call
      csv_content = result.to_a.join

      expect(result).to be_a(Enumerator)
      expect(csv_content).to include('ID,Name,Description,Value,Quantity,Available')
      expect(csv_content).to include('Test Product')
      expect(csv_content).to include('99.99')
    end
  end
end
