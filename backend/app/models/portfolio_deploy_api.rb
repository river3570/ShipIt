class PortfolioDeployApi < ApplicationRecord
  belongs_to :portfolio
  belongs_to :deploy_api_option
  validates :portfolio_id, uniqueness: { scope: :deploy_api_option_id }
end
