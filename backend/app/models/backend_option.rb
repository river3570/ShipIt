class BackendOption < ApplicationRecord
  validates :key,        presence: true, uniqueness: true, length: { maximum: 50 }
  validates :label,      presence: true, length: { maximum: 100 }
  validates :sort_order, presence: true

  scope :active,   -> { where(is_active: true).order(:sort_order) }
  scope :inactive, -> { where(is_active: false) }
end
