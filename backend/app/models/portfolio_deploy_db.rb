class PortfolioDeployDb < ApplicationRecord
  belongs_to :portfolio
  belongs_to :deploy_db_option
  validates :portfolio_id, uniqueness: { scope: :deploy_db_option_id }
end
