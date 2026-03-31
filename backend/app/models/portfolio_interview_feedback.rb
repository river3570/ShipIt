class PortfolioInterviewFeedback < ApplicationRecord
  belongs_to :portfolio
  belongs_to :interview_feedback_option
  validates :portfolio_id, uniqueness: { scope: :interview_feedback_option_id }
end
