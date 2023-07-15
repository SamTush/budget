require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      user = create(:user)
      sign_in user

      get :index

      expect(response).to be_successful
    end

    it 'assigns categories belonging to the current user' do
      user = create(:user)
      sign_in user
      category = create(:category, user: user)

      get :index

      expect(assigns(:categories)).to eq([category])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      user = create(:user)
      sign_in user
      category = create(:category, user: user)

      get :show, params: { id: category.id }

      expect(response).to be_successful
    end

    it 'assigns the category belonging to the current user' do
      user = create(:user)
      sign_in user
      category = create(:category, user: user)

      get :show, params: { id: category.id }

      expect(assigns(:category)).to eq(category)
    end

    it 'assigns the transactions belonging to the category' do
      user = create(:user)
      sign_in user
      category = create(:category, user: user)
      transaction = create(:transaction, category: category)

      get :show, params: { id: category.id }

      expect(assigns(:transactions)).to eq([transaction])
    end

    it 'raises an error if the category does not belong to the current user' do
      user = create(:user)
      sign_in user
      category = create(:category)

      expect {
        get :show, params: { id: category.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      user = create(:user)
      sign_in user

      get :new

      expect(response).to be_successful
    end

    it 'assigns a new category' do
      user = create(:user)
      sign_in user

      get :new

      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new category' do
        user = create(:user)
        sign_in user

        category_params = attributes_for(:category)

        expect {
          post :create, params: { category: category_params }
        }.to change(Category, :count).by(1)
      end

      it 'redirects to the categories index' do
        user = create(:user)
        sign_in user

        category_params = attributes_for(:category)

        post :create, params: { category: category_params }

        expect(response).to redirect_to(categories_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new category' do
        user = create(:user)
        sign_in user

        category_params = attributes_for(:category, name: '')

        expect {
          post :create, params: { category: category_params }
        }.not_to change(Category, :count)
      end

      it 'renders the new template' do
        user = create(:user)
        sign_in user

        category_params = attributes_for(:category, name: '')

        post :create, params: { category: category_params }

        expect(response).to render_template(:new)
      end
    end
  end
end
