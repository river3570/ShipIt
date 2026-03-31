class PortfolioFrontend < ApplicationRecord
  belongs_to :portfolio
  belongs_to :frontend_option
  validates :portfolio_id, uniqueness: { scope: :frontend_option_id }
end
