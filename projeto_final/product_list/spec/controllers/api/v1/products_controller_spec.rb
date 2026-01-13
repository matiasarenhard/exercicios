require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:product) { create(:product) }
  let(:valid_attributes) { attributes_for(:product) }
  let(:invalid_attributes) { { name: '', value: -1, description: '', quantity: -1 } }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all products' do
      create_list(:product, 3)
      get :index
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end

    it 'returns the product' do
      get :show, params: { id: product.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(product.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { product: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns the created product' do
        post :create, params: { product: valid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(valid_attributes[:name])
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new product' do
        expect {
          post :create, params: { product: invalid_attributes }
        }.not_to change(Product, :count)
      end

      it 'returns an unprocessable content status' do
        post :create, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) { attributes_for(:product, name: 'Updated Product') }

      it 'updates the product' do
        patch :update, params: { id: product.id, product: new_attributes }
        expect(Product.last.name).to eq('Updated Product')
      end

      it 'returns a successful response' do
        patch :update, params: { id: product.id, product: new_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable content status' do
        patch :update, params: { id: product.id, product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the product' do
      product_to_delete = create(:product)
      expect {
        delete :destroy, params: { id: product_to_delete.id }
      }.to change(Product, :count).by(-1)
    end

    it 'returns no content status' do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #export' do
    let!(:product) { create(:product, name: 'Test Product') }

    before { get :export }

    it 'returns CSV with correct headers' do
      expect(response.headers['Content-Type']).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to include('products-')
      expect(response.headers['Content-Disposition']).to include('.csv')
    end

    it 'includes CSV data' do
      csv_content = response.body.to_a.join
      expect(csv_content).to include('ID,Name,Description,Value,Quantity,Available')
      expect(csv_content).to include('Test Product')
    end
  end
end