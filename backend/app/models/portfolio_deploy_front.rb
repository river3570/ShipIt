class PortfolioDeployFront < ApplicationRecord
  belongs_to :portfolio
  belongs_to :deploy_front_option
  validates :portfolio_id, uniqueness: { scope: :deploy_front_option_id }
end
