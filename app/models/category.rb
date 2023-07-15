class Category < ApplicationRecord
  validates :name, :icon, presence: true

    belongs_to :user
    has_many :transactions

    def total_amount
        transactions.sum(:amount)
      end
end
