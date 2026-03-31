class PortfolioInfra < ApplicationRecord
  belongs_to :portfolio
  belongs_to :infra_option
  validates :portfolio_id, uniqueness: { scope: :infra_option_id }
end
