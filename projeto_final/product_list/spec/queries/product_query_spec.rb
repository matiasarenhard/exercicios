require 'rails_helper'

RSpec.describe ProductQuery do
  let!(:product1) { create(:product, name: 'Sleek Concrete Shirt', description: 'A comfortable shirt', value: 100.0, quantity: 10) }
  let!(:product2) { create(:product, name: 'Modern Cotton Pants', description: 'Sleek design pants', value: 150.0, quantity: 5) }
  let!(:product3) { create(:product, name: 'Vintage Jacket', description: 'Old style jacket', value: 200.0, quantity: 3) }
  let!(:product4) { create(:product, name: 'Sport Shoes', description: 'Running shoes', value: 80.0, quantity: 20) }

  describe '#initialize' do
    context 'with default parameters' do
      let(:query) { described_class.new }

      it 'sets default values' do
        expect(query.search_term).to eq('')
        expect(query.page).to eq(1)
        expect(query.per_page).to eq(10)
      end
    end

    context 'with custom parameters' do
      let(:query) { described_class.new(search_term: 'Sleek', page: 2, per_page: 5) }

      it 'sets custom values' do
        expect(query.search_term).to eq('Sleek')
        expect(query.page).to eq(2)
        expect(query.per_page).to eq(5)
      end
    end

    context 'with invalid parameters' do
      let(:query) { described_class.new(search_term: '  ', page: 0, per_page: -1) }

      it 'sets default values for invalid inputs' do
        expect(query.search_term).to eq('')
        expect(query.page).to eq(1)
        expect(query.per_page).to eq(10)
      end
    end

    context 'with string parameters' do
      let(:query) { described_class.new(search_term: 'test', page: '3', per_page: '15') }

      it 'converts string parameters to integers' do
        expect(query.page).to eq(3)
        expect(query.per_page).to eq(15)
      end
    end
  end

  describe '#run' do
    context 'without search term' do
      let(:query) { described_class.new }

      it 'returns all products paginated' do
        result = query.run
        expect(result.count).to eq(4)
        expect(result).to include(product1, product2, product3, product4)
      end
    end

    context 'with search term matching name OR description' do
      let(:query) { described_class.new(search_term: 'Sleek') }

      it 'returns products with matching name or description (OR logic)' do
        result = query.run
        expect(result.count).to eq(2)
        expect(result).to include(product1, product2)
        expect(result).not_to include(product3, product4)
      end
    end

    context 'with search term matching only description' do
      let(:query) { described_class.new(search_term: 'design') }

      it 'returns products with matching description' do
        result = query.run
        expect(result.count).to eq(1)
        expect(result).to include(product2)
        expect(result).not_to include(product1, product3, product4)
      end
    end

    context 'with numeric search term matching quantity' do
      let(:query) { described_class.new(search_term: '10') }

      it 'returns products with matching quantity' do
        result = query.run
        expect(result.count).to eq(1)
        expect(result).to include(product1)
      end
    end

    context 'with numeric search term matching value' do
      let(:query) { described_class.new(search_term: '100') }

      it 'returns products with matching value or quantity' do
        result = query.run
        expect(result).to include(product1)
      end
    end

    context 'with search term that matches nothing' do
      let(:query) { described_class.new(search_term: 'nonexistent') }

      it 'returns empty result' do
        result = query.run
        expect(result.count).to eq(0)
      end
    end

    context 'with pagination' do
      let(:query) { described_class.new(page: 1, per_page: 2) }

      it 'returns paginated results' do
        result = query.run
        expect(result.count).to eq(2)
        expect(result.current_page).to eq(1)
        expect(result.limit_value).to eq(2)
      end
    end

    context 'with search term and pagination' do
      let(:query) { described_class.new(search_term: 'Sleek', page: 1, per_page: 1) }

      it 'returns paginated search results' do
        result = query.run
        expect(result.count).to eq(1)
        expect(result.current_page).to eq(1)
        expect(result.limit_value).to eq(1)
        expect(result.total_count).to eq(2) 
      end
    end

    context 'with unique search term' do
      let(:query) { described_class.new(search_term: 'Vintage') }

      it 'returns only matching product' do
        result = query.run
        expect(result.count).to eq(1)
        expect(result).to include(product3)
      end
    end
  end
end