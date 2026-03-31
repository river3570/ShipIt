class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :experience_level_option, optional: true

  has_many :portfolios, dependent: :destroy
  has_many :portfolio_reactions, dependent: :destroy
  has_many :reacted_portfolios, through: :portfolio_reactions, source: :portfolio

  has_many :follower_follows,  class_name: "Follow", foreign_key: :followee_id, dependent: :destroy
  has_many :followee_follows,  class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :followers,         through: :follower_follows,  source: :follower
  has_many :followees,         through: :followee_follows,  source: :followee

  validates :username, length: { maximum: 30 }, allow_blank: true
end
