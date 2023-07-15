require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe 'GET #index' do
    let(:category) { create(:category) }

    before do
      get :index, params: { category_id: category.id }
    end

    it 'assigns the category' do
      expect(assigns(:category)).to eq(category)
    end

    it 'assigns the transactions ordered by created_at' do
      transactions = category.transactions.order(created_at: :desc)
      expect(assigns(:transactions)).to eq(transactions)
    end

    it 'assigns the total amount for the category' do
      total_amount = category.transactions.sum(:amount)
      expect(assigns(:total_amount)).to eq(total_amount)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    let(:category) { create(:category) }

    before do
      get :new, params: { category_id: category.id }
    end

    it 'assigns the category' do
      expect(assigns(:category)).to eq(category)
    end

    it 'assigns a new transaction' do
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:category) { create(:category) }

    context 'with valid parameters' do
      let(:valid_params) { { name: 'Transaction', amount: 10, category_ids: [category.id] } }

      it 'creates a new transaction' do
        expect do
          post :create, params: { category_id: category.id, transaction: valid_params }
        end.to change(Transaction, :count).by(1)
      end

      it "redirects to the category's transactions page" do
        post :create, params: { category_id: category.id, transaction: valid_params }
        expect(response).to redirect_to(category_transactions_path(category))
      end

      it 'sets a success flash notice' do
        post :create, params: { category_id: category.id, transaction: valid_params }
        expect(flash[:notice]).to eq('Transaction created successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: nil, amount: 10, category_ids: [category.id] } }

      it 'does not create a new transaction' do
        expect do
          post :create, params: { category_id: category.id, transaction: invalid_params }
        end.to_not change(Transaction, :count)
      end

      it 'renders the new template' do
        post :create, params: { category_id: category.id, transaction: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end
end
