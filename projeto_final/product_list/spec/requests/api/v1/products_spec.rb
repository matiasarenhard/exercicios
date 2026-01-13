require 'swagger_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  path '/api/v1/products' do
    get 'List products' do
      tags 'Products'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, required: false, description: 'Search term'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'

      response '200', 'products found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              value: { type: :number },
              quantity: { type: :integer },
              available: { type: :boolean }
            }
          }

        run_test!
      end
    end

    post 'Create a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              value: { type: :number },
              quantity: { type: :integer },
              available: { type: :boolean }
            },
            required: %w[name description value quantity]
          }
        }
      }

      response '201', 'product created' do
        let(:product) { { product: attributes_for(:product) } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:product) { { product: { name: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Show a product' do
      tags 'Products'
      produces 'application/json'

      response '200', 'product found' do
        let(:id) { create(:product).id }
        run_test!
      end

      response '404', 'product not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    patch 'Update a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              value: { type: :number },
              quantity: { type: :integer },
              available: { type: :boolean }
            }
          }
        }
      }

      response '200', 'product updated' do
        let(:id) { create(:product).id }
        let(:product) { { product: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:product).id }
        let(:product) { { product: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a product' do
      tags 'Products'

      response '204', 'product deleted' do
        let(:id) { create(:product).id }
        run_test!
      end
    end
  end

  path '/api/v1/products/export' do
    get 'Export products to CSV' do
      tags 'Products'
      produces 'text/csv'

      response '200', 'CSV file' do
        run_test!
      end
    end
  end
end
