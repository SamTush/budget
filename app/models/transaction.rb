class Transaction < ApplicationRecord
  belongs_to :category
  has_many :category_transactions
  has_many :categories, through: :category_transactions

  accepts_nested_attributes_for :categories
end
  