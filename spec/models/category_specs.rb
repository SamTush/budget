require 'rails_helper'

RSpec.describe Category, type: :model do
    describe "validations" do
      it "is valid with a name" do
        category = Category.new(name: "Food")
        expect(category).to be_valid
      end
  
      it "is invalid without a name" do
        category = Category.new(name: nil)
        expect(category).to_not be_valid
      end
    end
  end
  