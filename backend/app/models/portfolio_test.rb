class PortfolioTest < ApplicationRecord
  belongs_to :portfolio
  belongs_to :test_option
  validates :portfolio_id, uniqueness: { scope: :test_option_id }
end
