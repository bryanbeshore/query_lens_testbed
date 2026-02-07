class Team < ApplicationRecord
  enum :plan, { free: 0, starter: 1, pro: 2, enterprise: 3 }

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :posts, dependent: :destroy
  has_many :invoices, dependent: :destroy
end
