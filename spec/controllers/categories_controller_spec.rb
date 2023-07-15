# spec/controllers/categories_controller_spec.rb
require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  before { sign_in(user) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns categories belonging to the current user" do
      user_categories = create_list(:category, 3, user: user)
      other_user_categories = create_list(:category, 2)

      get :index
      expect(assigns(:categories)).to match_array(user_categories)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: category.id }
      expect(response).to be_successful
    end

    it "assigns the category belonging to the current user" do
      get :show, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
    end

    it "assigns the transactions belonging to the category" do
      transactions = create_list(:transaction, 3, category: category)

      get :show, params: { id: category.id }
      expect(assigns(:transactions)).to match_array(transactions)
    end

    it "raises an error if the category does not belong to the current user" do
      other_user_category = create(:category)

      expect {
        get :show, params: { id: other_user_category.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new category" do
      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { attributes_for(:category) }

      it "creates a new category" do
        expect {
          post :create, params: { category: valid_params }
        }.to change(Category, :count).by(1)
      end

      it "redirects to the categories index" do
        post :create, params: { category: valid_params }
        expect(response).to redirect_to(categories_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { attributes_for(:category, name: nil) }

      it "does not create a new category" do
        expect {
          post :create, params: { category: invalid_params }
        }.not_to change(Category, :count)
      end

      it "renders the new template" do
        post :create, params: { category: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end
end
