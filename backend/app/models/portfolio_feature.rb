class PortfolioFeature < ApplicationRecord
  belongs_to :portfolio
  belongs_to :feature_option
  validates :portfolio_id, uniqueness: { scope: :feature_option_id }
end
