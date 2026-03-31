class PortfolioBackend < ApplicationRecord
  belongs_to :portfolio
  belongs_to :backend_option
  validates :portfolio_id, uniqueness: { scope: :backend_option_id }
end
