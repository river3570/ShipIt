class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :target_category, class_name: "TargetCategory", optional: true

  has_many :portfolio_reactions, dependent: :destroy
  has_many :reacted_by_users, through: :portfolio_reactions, source: :user

  has_many :portfolio_features,            dependent: :destroy
  has_many :feature_options,               through: :portfolio_features

  has_many :portfolio_frontends,           dependent: :destroy
  has_many :frontend_options,              through: :portfolio_frontends

  has_many :portfolio_backends,            dependent: :destroy
  has_many :backend_options,               through: :portfolio_backends

  has_many :portfolio_databases,           dependent: :destroy
  has_many :db_options,                    through: :portfolio_databases

  has_many :portfolio_tests,               dependent: :destroy
  has_many :test_options,                  through: :portfolio_tests

  has_many :portfolio_cicds,               dependent: :destroy
  has_many :cicd_options,                  through: :portfolio_cicds

  has_many :portfolio_infras,              dependent: :destroy
  has_many :infra_options,                 through: :portfolio_infras

  has_many :portfolio_deploy_fronts,       dependent: :destroy
  has_many :deploy_front_options,          through: :portfolio_deploy_fronts

  has_many :portfolio_deploy_apis,         dependent: :destroy
  has_many :deploy_api_options,            through: :portfolio_deploy_apis

  has_many :portfolio_deploy_dbs,          dependent: :destroy
  has_many :deploy_db_options,             through: :portfolio_deploy_dbs

  has_many :portfolio_interview_feedbacks, dependent: :destroy
  has_many :interview_feedback_options,    through: :portfolio_interview_feedbacks

  enum :status, { draft: 0, published: 1 }
  enum :build_period_type, { weeks: 0, months: 1, range: 2 }

  validates :name,    presence: true, length: { maximum: 120 }
  validates :summary, presence: true, length: { maximum: 280 }
end
