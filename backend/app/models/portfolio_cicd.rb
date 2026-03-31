class PortfolioCicd < ApplicationRecord
  belongs_to :portfolio
  belongs_to :cicd_option
  validates :portfolio_id, uniqueness: { scope: :cicd_option_id }
end
