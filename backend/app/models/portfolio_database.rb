class PortfolioDatabase < ApplicationRecord
  belongs_to :portfolio
  belongs_to :db_option
  validates :portfolio_id, uniqueness: { scope: :db_option_id }
end
